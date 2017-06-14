## GUIDE TO AUTH2 Authentication in R Shiny (or other online apps)
##
## Mark Edmondson 2015-02-16 - @HoloMarkeD | http://markedmondson.me
##
## v 0.1
##
##
## Go to the Google API console and activate the APIs you need. https://code.google.com/apis/console/?pli=1
## Get your client ID, and client secret for use below, and put in the URL of your app in the redirect URIs
##  e.g. I put in https://mark.shinyapps.io/ga-effect/ for the GA Effect app,
## and http://127.0.0.1:6423 for local testing (start the Shiny App by using this command to force the port: runApp(port=6423)
##
## I then have an auth.r file I source which is below
##

## auth.r

CLIENT_ID      <-  "500da4551e66466cb36537fa14a21a99"
CLIENT_SECRET  <-  "506feca2db304a16ae9834f4078e4a79"
CLIENT_URL     <-  "http://127.0.0.1:6423"
# CLIENT_URL     <-  'http://127.0.0.1:6423'  # I comment this out for deployment, in for local testing

### Authentication functions

## generate the URL the user clicks on.
## The redirect URL is then returned to with the extra 'code' and 'state' URL parameters appended to it.
ShinyGetTokenURL <- function(client.id     = CLIENT_ID,
                             client.secret = CLIENT_SECRET,
                             redirect.uri  = CLIENT_URL) {

  url <- paste('https://accounts.spotify.com/authorize?',
               'redirect_uri=', redirect.uri, '&',
               'response_type=code&',
               'client_id=', client.id, sep='', collapse='');
  return(url)
}

## gets the token from Google once you have the code that is in the return URL
ShinyGetToken <- function(code,
                          client.id     = CLIENT_ID,
                          client.secret = CLIENT_SECRET,
                          redirect.uri  = CLIENT_URL){

  token <- MErga.authenticate(client.id = client.id,
                              client.secret = client.secret,
                              code = code,
                              redirect.uri = redirect.uri);

  return(token)
}

## posts your code to google to get the current refresh
MErga.authenticate <- function(client.id, client.secret, code, redirect.uri) {
  opts <- list(verbose = FALSE);
  raw.data <- postForm("https://accounts.spotify.com/api/token",
                       .opts = opts,
                       code = code,
                       client_id = client.id,
                       client_secret = client.secret,
                       redirect_uri = redirect.uri,
                       grant_type = 'authorization_code',
                       style = 'POST');

  token.data <- fromJSON(raw.data);
  now <- as.numeric(Sys.time());
  token <- c(token.data, timestamp = c('first'=now, 'refresh'=now));

  return(token);
}
#### end auth.r
