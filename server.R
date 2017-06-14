shinyServer(function(input, output, session) {

  ### Authentication Functions ########################################################
  ##
  ##   AuthCode() - checks for presence of code in URL
  ##   AccessToken() - creates a token once a code is available
  ##   ShinyMakeGAProfileTable - the table of profiles taken from API
  ##   output$AuthGAURL - creates the authentication URL
  ##   output$GAProfile - table of the profiles belonging to user

  AuthCode  <- reactive({

    ## gets all the parameters in the URL. Your authentication code should be one of them
    pars <- parseQueryString(session$clientData$url_search)

    if(length(pars$code) > 0){
      return(pars$code)
    }
  })

  AccessToken <- reactive({
    validate(
      need(AuthCode(), "Authenticate To See")
    )
    access_token <- ShinyGetToken(code = AuthCode())

    access_token$access_token
  })

  output$AuthGAURL <- renderUI({
    a("Click to Authorise Spotify Access", href=ShinyGetTokenURL())
  })

  ShinyMakeGAProfileTable <- reactive({

    token <- AccessToken()
  })

  genres <- reactive({
    resp <- GET("https://api.spotify.com/v1/recommendations/available-genre-seeds",
                add_headers(Authorization = sprintf("Bearer %s", ShinyMakeGAProfileTable())))
    content(resp)$genres
  })

  categories <- reactive({

  })

  output$genres <- renderUI({
    selectInput("genres", "Genre", c = genres())
  })

  me <- reactive({
    req(ShinyMakeGAProfileTable())
    GET("https://api.spotify.com/v1/me",
        add_headers(Authorization = sprintf("Bearer %s", ShinyMakeGAProfileTable())))
  })

  # browse.new.releases <- reactive({
  #   req(ShinyMakeGAProfileTable())
  #   GET("https://api.spotify.com/v1/browse/new-releases",
  #       add_headers(Authorization = "Bearer %s"))
  # })

  output$token <- renderText({
    ShinyMakeGAProfileTable()
  })

  output$new_releases <- renderDataTable({
    resp <- GET(sprintf("https://api.spotify.com/v1/browse/new-releases?limit=%s", input$nr.limit),
                add_headers(Authorization = sprintf("Bearer %s", ShinyMakeGAProfileTable())))
    c <- content(resp)
    data <- data.frame(artist = sapply(1:length(c$albums$items), function(x) c$albums$items[[x]]$artists[[1]]$name),
                       album = sapply(1:length(c$albums$items), function(x) c$albums$items[[x]]$name))
    datatable(data)
  })

  output$stonesthrow.catalog <- renderDataTable({
    datatable(stonesthrow)
  })

  output$playlists <- renderDataTable({
    resp <- GET("https://api.spotify.com/v1/me/playlists",
                add_headers(Authorization = sprintf("Bearer %s", ShinyMakeGAProfileTable())))
    c <- content(resp)
    data <- data.frame(playlist = sapply(1:length(c$items), function(x) c$items[[x]]$name),
                       tracks = sapply(1:length(c$items), function(x) c$items[[x]]$tracks$total),
                       href = sapply(1:length(c$items), function(x) c$items[[x]]$href))
    datatable(data)
  })

  # append_criteria <- function(item) {
  #   if(input[[item]] == TRUE) {
  #     url <<- paste0(url, sprintf("&min_%s=%s", name, input[[name]]), collapse = "")
  #   }
  # }

  recommendation <- reactive({
    url <- "https://api.spotify.com/v1/recommendations?seed_artists=4NHQUGzhtTLFvgF5SZesLK"
    if (input$energy_on == TRUE) {
      url <- paste0(url, sprintf("&%s_energy=%s", input$energy_mode, input$energy), collapse = "")
    }
    url
  })

  output$recommendations <- renderDataTable({
    # append_criteria("energy")
    # if(input$energy == TRUE) {
    #   paste0(url, sprintf("&min_energy=%s", input$energy), collapse = "")
    # }
    # if(input$energy == TRUE) {
    #   paste0(url, sprintf("&min_energy=%s", input$energy), collapse = "")
    # }
    # if(input$energy == TRUE) {
    #   paste0(url, sprintf("&min_energy=%s", input$energy), collapse = "")
    # }
    # if(input$energy == TRUE) {
    #   paste0(url, sprintf("&min_energy=%s", input$energy), collapse = "")
    # }
    # if(input$energy == TRUE) {
    #   paste0(url, sprintf("&min_energy=%s", input$energy), collapse = "")
    # }

    resp <- GET(recommendation(),
                add_headers(Authorization = sprintf("Bearer %s", ShinyMakeGAProfileTable())))
    c <- content(resp)
    recs <- data.frame(track = sapply(c$tracks, function(x) x$name),
                       artist = sapply(c$tracks, function(x) x$artists[[1]]$name))
    datatable(recs)
  })

})
  ## end server.r

# METHOD	ENDPOINT	USAGE	RETURNS	OAUTH
# GET
# /v1/albums/{id}	Get an album	album	OAuth
# GET	/v1/albums?ids={ids}
# Get several albums	albums	OAuth
# GET	/v1/albums/{id}/tracks	Get an album's tracks	tracks*	OAuth
# GET
# /v1/artists/{id}
# Get an artist	artist	OAuth
# GET
# /v1/artists?ids={ids}
# Get several artists	artists	OAuth
# GET	/v1/artists/{id}/albums	Get an artist's albums	albums*	OAuth
# GET	/v1/artists/{id}/top-tracks	Get an artist's top tracks	tracks	OAuth
# GET	/v1/artists/{id}/related-artists	Get an artist's related artists	artists	OAuth
# GET	v1/audio-analysis/{id}	Get Audio Analysis for a Track	audio analysis object	OAuth
# GET	/v1/audio-features/{id}	Get audio features for a track	audio features	OAuth
# GET	/v1/audio-features?ids={ids}	Get audio features for several tracks	audio features	OAuth
# GET	/v1/browse/featured-playlists	Get a list of featured playlists	playlists	OAuth
# GET	/v1/browse/new-releases	Get a list of new releases	albums*	OAuth
# GET	/v1/browse/categories	Get a list of categories	categories	OAuth
# GET	/v1/browse/categories/{id}	Get a category	category	OAuth
# GET	/v1/browse/categories/{id}/playlists	Get a category's playlists	playlists*	OAuth
# GET	/v1/me	Get current user's profile	user	OAuth
# GET	/v1/me/following	Get Followed Artists	artists	OAuth
# PUT	/v1/me/following	Follow Artists or Users	-	OAuth
# DELETE	/v1/me/following	Unfollow Artists or Users	-	OAuth
# GET	/v1/me/following/contains	Check if User Follows Users or Artists	true/false	OAuth
# PUT	/v1/users/{owner_id}/playlists/{playlist_id}/followers	Follow a Playlist	-	OAuth
# DELETE	/v1/users/{owner_id}/playlists/{playlist_id}/followers	Unfollow a Playlist	-	OAuth
# PUT	/v1/me/tracks?ids={ids}
# Save tracks for user	-	OAuth
# GET
# /v1/me/tracks
# Get user's saved tracks	saved tracks	OAuth
# DELETE	/v1/me/tracks?ids={ids}	Remove user's saved tracks	-	OAuth
# GET
# /v1/me/tracks/contains?ids={ids}
# Check user's saved tracks	true/false	OAuth
# PUT	/v1/me/albums?ids={ids}
# Save albums for user	-	OAuth
# GET
# /v1/me/albums
# Get user's saved albums	saved albums	OAuth
# DELETE	/v1/me/albums?ids={ids}	Remove user's saved albums	-	OAuth
# GET
# /v1/me/albums/contains?ids={ids}
# Check user's saved albums	true/false	OAuth
# GET	/v1/me/top/{type}	Get a user's top artists or tracks	artists or tracks	OAuth
# GET	/v1/recommendations	Get recommendations based on seeds	recommendations object	OAuth
# GET
# /v1/search?type=album	Search for an album	albums*	OAuth
# GET
# /v1/search?type=artist
# Search for an artist	artists	OAuth
# GET	/v1/search?type=playlist	Search for a playlist	playlists*	OAuth
# GET	/v1/search?type=track	Search for a track	tracks	OAuth
# GET
# /v1/tracks/{id}
# Get a track	tracks	OAuth
# GET
# /v1/tracks?ids={ids}
# Get several tracks	tracks	OAuth
# GET
# /v1/users/{user_id}
# Get a user's profile	user*	OAuth
# GET	/v1/users/{user_id}/playlists	Get a list of a user's playlists	playlists*	OAuth
# GET	/v1/me/playlists	Get a list of the current user's playlists	playlists*	OAuth
# GET	/v1/users/{user_id}/playlists/{playlist_id}	Get a playlist	playlist	OAuth
# GET	/v1/users/{user_id}/playlists/{playlist_id}/tracks	Get a playlist's tracks	tracks	OAuth
# POST	/v1/users/{user_id}/playlists	Create a playlist	playlist	OAuth
# PUT	/v1/users/{user_id}/playlists/{playlist_id}	Change a playlist's details	-	OAuth
# POST	/v1/users/{user_id}/playlists/{playlist_id}/tracks	Add tracks to a playlist	-	OAuth
# DELETE	/v1/users/{user_id}/playlists/{playlist_id}/tracks	Remove tracks from a playlist	snapshot_id	OAuth
# PUT	/v1/users/{user_id}/playlists/{playlist_id}/tracks	Reorder a playlist's tracks	snapshot_id	OAuth
# PUT	/v1/users/{user_id}/playlists/{playlist_id}/tracks	Replace a playlist's tracks	-	OAuth
# GET	/v1/users/{user_id}/playlists/{playlist_id}/followers/contains	Check if Users Follow a Playlist	true/false	OAuth
# GET	v1/me/player/recently-played	Get Current User’s Recently Played Tracks	play history object	OAuth
# GET	/v1/me/player/devices	Get a User’s Available Devices		OAuth
# GET	/v1/me/player	Get Information About The User’s Current Playback		OAuth
# GET	/v1/me/player/currently-playing	Get the User’s Currently Playing Track		OAuth
# PUT	/v1/me/player	Transfer a User’s Playback		OAuth
# PUT	/v1/me/player/play	Start/Resume a User’s Playback		OAuth
# PUT	/v1/me/player/pause	Pause a User’s Playback		OAuth
# POST	/v1/me/player/next	Skip User’s Playback To Next Track		OAuth
# POST	/v1/me/player/previous	Skip User’s Playback To Previous Track		OAuth
# PUT	v1/me/player/seek	Seek To Position In Currently Playing Track		OAuth
# PUT	/v1/me/player/repeat	Set Repeat Mode On User’s Playback		OAuth
# PUT	/v1/me/player/volume	Set Volume For User’s Playback		OAuth
# PUT	/v1/me/player/shuffle	Toggle Shuffle For User’s Playback		OAuth