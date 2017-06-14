fluidPage(
  column(10, offset = 1,
         h4("gfella"),
         tabsetPanel(
           tabPanel("Authorize",
                    fluidRow(
                      column(12,
                             uiOutput("AuthGAURL")
                      )
                    )
           ),
           tabPanel("Releases",
                    tabsetPanel(
                      tabPanel("New",
                               fluidRow(
                                 column(2,
                                        numericInput("nr.limit", "Limit", 20, 1, 50)
                                 ),
                                 column(10,
                                        dataTableOutput("new_releases")
                                 )
                               )
                      ),
                      tabPanel("Stones Throw Records",
                               dataTableOutput("stonesthrow.catalog")
                      ),
                      tabPanel("Def Jux"),
                      tabPanel("Fools Gold"),
                      tabPanel("Top Dawg")
                    )
           ),
           tabPanel("Playlists",
                    fluidRow(
                      column(12,
                             dataTableOutput("playlists")
                      )
                    )
           ),
           tabPanel("Recommendations",
                    fluidRow(
                      column(2,
                             uiOutput("genres"),
                             search.cat("Acousticness", 0, 0, 1, .1),
                             search.cat("Danceability"),
                             search.cat("Duration_ms"),
                             search.cat("Energy"),
                             search.cat("Instrumentalness"),
                             selectInput("key", "Key", c = p),
                             search.cat("Liveness"),
                             search.cat("Loudness"),
                             search.cat("Mode"),
                             search.cat("Popularity", max = 100),
                             search.cat("Speechiness"),
                             search.cat("Tempo"),
                             search.cat("Time_signature"),
                             search.cat("Valence")
                      ),
                      column(10,
                             dataTableOutput("recommendations")
                      )
                    )
           )
         )
  )
)
