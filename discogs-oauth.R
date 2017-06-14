library(httr)
library(rjson)

key <- "bBCuDgKpHAxAfbDhLMNS"
secret <- "bxIgUaVLAAAxNfDzfiPByQpgHbWZBIsp"
base <- "https://api.discogs.com/"
request <- "oauth/request_token"
authorize <- "oauth/authorize"
access <-	"oauth/access_token"


gfella <- oauth_app("gfella", key, secret)
endpoints <- oauth_endpoint(request, authorize, access, base_url = base)
token <- oauth1.0_token(endpoints, gfella, cache = FALSE)

ua <- user_agent("gfella/0.1")



artists <- "/artists/1"


g.query <- function(q) {
  sprintf("/database/search?q={%s}&key=%s&secret=%s", q, key, secret)
}

gfella_api <- function(path, q = NULL) {
  url <- modify_url("https://api.discogs.com", path = path)

  resp <- GET(url, ua, query = list(q = q,
                                    key = key,
                                    secret = secret))
  # if (http_type(resp) != "application/json") {
  #   stop("API did not return json", call. = FALSE)
  # }

  parsed <- fromJSON(content(resp, "text"), simplifyVector = FALSE)

  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "gfella_api"
  )
}

print.gfella_api <- function(x, ...) {
  cat("<gfella ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}


format_entry <- function(r) {
  style <- sapply(seq(1:length(r)), function(z) paste0(sapply(seq(1:length(resp$content$results[[z]]$style)), function(x) resp$content$results[[z]]$style[[x]]), collapse = ", "))
  thumb <- resp$content$results[[50]]$thumb
  format <- paste0(sapply(seq(1:length(resp$content$results[[50]]$format)), function(x) resp$content$results[[50]]$format[[x]]), collapse = ", ")
  country <- resp$content$results[[50]]$country
  barcode <- resp$content$results[[50]]$barcode
  uri <- resp$content$results[[50]]$uri
  community.have <- resp$content$results[[50]]$community$have
  community.want <- resp$content$results[[50]]$community$want
  label <- paste0(sapply(seq(1:length(resp$content$results[[50]]$label)), function(x) resp$content$results[[50]]$label[[x]]), collapse = ", ")
  catno <- resp$content$results[[50]]$catno
  year <- resp$content$results[[50]]$year
  genre <- paste0(sapply(seq(1:length(resp$content$results[[50]]$genre)), function(x) resp$content$results[[50]]$genre[[x]]), collapse = ", ")
  title <- resp$content$results[[50]]$title
  resource_url <- resp$content$results[[50]]$resource_url
  type <- resp$content$results[[50]]$type
  id <- resp$content$results[[50]]$id

  data.frame(style, thumb, format, country,
             ifelse(length(barcode) == 0, 0, barcode),
             uri, community.have, community.want,
             label, catno, year, genre, title,
             resource_url, type, id)
}

hot100 <- htmlParse(content(GET("http://www.billboard.com/charts/hot-100")))
hot100chart <- getNodeSet(hot100, "//article[contains(@class, 'chart-row')]")
chartrows <- lapply(1:length(hot100chart), function(x) getNodeSet(hot100chart[[x]], ".//div[contains(@class, 'chart-row')]")[[1]])
getNodeSet(chartrow, ".//div[contains(@class, 'chart-row')]")

hot100 <- read_html(GET("http://www.billboard.com/charts/hot-100"))

xml_find_all(hot100, ".//article[contains(@class, 'data-tracklabel')]")


r <- sapply(1:100, function(x) as_list(xml_find_all(hot100, ".//article[contains(@class, 'chart-row')]")[x]))

sapply(1:length(r), function(x) {
  # title <-  r[[x]][[1]][[8]][[6]][[2]][[2]][[1]]
  artist <- r[[x]][[1]][[8]][[6]][[2]][[4]][[1]]
  lastweek <- r[[x]][[1]][[8]][[2]][[4]][[1]]
  current.week <- r[[x]][[1]][[8]][[2]][[2]][[1]]

  # c(title, artist, lastweek, current.week)
  title
})