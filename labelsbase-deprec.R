unlist(lapply(1, function(x) {
  doc <- content(GET(sprintf("https://labelsbase.net/labels?page=%s", x)))
  label <- sapply(getNodeSet(xmlRoot(htmlParse(doc)),
                             "//div[contains(normalize-space(@class), 'label-item')]/div/a"),
                  xmlValue)
  label <- label[which((1:length(labeldata) %% 2) == 0)]
  genre <- sapply(getNodeSet(xmlRoot(htmlParse(doc)),
                             "//small[contains(normalize-space(@title), 'Genres')]/b"),
                  xmlValue)
  data.frame(label, genre)
}))

unlist(lapply(1:2, function(x) {
  doc <- content(GET(sprintf("https://labelsbase.net/labels?page=%s", x)))

}))
