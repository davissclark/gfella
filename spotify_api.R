library(httr)
library(rjson)


base <- "https:///"
request <- "oauth/request_token"
authorize <- "authorize"
access <-	"api/token"

scope <- "playlist-read-private playlist-modify-private"

# GET https://accounts.spotify.com/authorize/?client_id=5fe01282e44241328a84e7c5cc169165&response_type=code&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback&scope=user-read-private%20user-read-email&state=34fFs29kd09


spotify <- oauth_app("gfella", key, secret)

endpoint <- oauth_endpoint(authorize = "authorize", request = "oauth/request_token", access =	"api/token", base_url = "https://accounts.spotify.com/", )

oauth2.0_token(endpoint, app = spotify, scope = scope, user_params = NULL,
               type = NULL, use_oob = FALSE)


## auth.r
CLIENT_ID      <-  "YOUR CLIENT ID"
CLIENT_SECRET  <-  "YOUR CLIENT SECRET"
CLIENT_URL     <-  'https://your-url-that-picks-up-return-token.com'
# CLIENT_URL     <-  'http://127.0.0.1:6423'  # I comment this out for deployment, in for local testing

### Authentication functions

## generate the URL the user clicks on.
## The redirect URL is then returned to with the extra 'code' and 'state' URL parameters appended to it.



ShinyGetTokenURL <- function(client.id     = CLIENT_ID,
                             client.secret = CLIENT_SECRET,
                             redirect.uri  = CLIENT_URL) {

  url <- paste('https://accounts.google.com/o/oauth2/auth?',
               'scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fanalytics+',  ## plus any other scopes you need
               'https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fanalytics.readonly&',
               'state=securitytoken&',
               'redirect_uri=', redirect.uri, '&',
               'response_type=code&',
               'client_id=', client.id, '&',
               'approval_prompt=auto&',
               'access_type=online', sep='', collapse='');
  return(url)
}