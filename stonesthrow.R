stonesthrow <- "https://www.stonesthrow.com/catalog"

doc <- content(GET(stonesthrow))
data <- sapply(getNodeSet(htmlParse(doc), "//td"),xmlValue)
data <- data[9:2900]

stonesthrow <- data.frame(
  year = data[seq(1, 2892, by = 6)],
  artist = data[seq(2, 2892, by = 6)],
  title = data[seq(3, 2892, by = 6)],
  label = data[seq(4, 2892, by = 6)],
  format = data[seq(5, 2892, by = 6)],
  cat.no = data[seq(6, 2892, by = 6)]
)