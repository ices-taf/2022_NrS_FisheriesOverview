library(icesTAF)
library(icesFO)

areas <- load_areas("Greater North Sea")

sf::st_write(areas, "areas.csv", layer_options = "GEOMETRY=AS_WKT")
