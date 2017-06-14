options(shiny.port = 6423)

library(shiny)
library(DT)
library(RCurl)
library(httr)
library(XML)
library(rjson)

sapply(c("auth.R", "stonesthrow.R"), source)

search.cat <- function(name, value = 0, min = 0, max = 1, step = .1) {
  fluidRow(
    checkboxInput(sprintf("%s_on", tolower(name)), name, value = FALSE),
    conditionalPanel(condition = sprintf("input.%s_on == true", tolower(name)),
                     numericInput(tolower(name), NA, value = value, min = min, max = max, step = step),
                     checkboxGroupInput(sprintf("%s_mode", tolower(name)), NA, list("min", "max"))
    )
  )
}


pitch <- data.frame(
  pitch = c("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"),
  integer = c(0:11)
)

p <- as.list(pitch$integer)
names(p) <- pitch$pitch

item.types <- c("album", "artist", "track", "playlist")

# 0	C (also B♯, Ddouble flat)
# 1	C♯, D♭ (also Bdouble sharp)
# 2	D (also Cdouble sharp, Edouble flat)
# 3	D♯, E♭ (also Fdouble flat)
# 4	E (also Ddouble sharp, F♭)
# 5	F (also E♯, Gdouble flat)
# 6	F♯, G♭ (also Edouble sharp)
# 7	G (also Fdouble sharp, Adouble flat)
# 8	G♯, A♭
# 9	A (also Gdouble sharp, Bdouble flat)
# 10, t or A	A♯, B♭ (also Cdouble flat)
# 11, e or B	B (also Adouble sharp, C♭)
