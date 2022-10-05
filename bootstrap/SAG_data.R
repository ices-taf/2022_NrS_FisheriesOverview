library(icesTAF)
library(icesFO)
library(dplyr)


out <- load_sag(2022, "Greater North Sea")

sag_complete <- out
write.taf(out, file = "SAG_complete_BtS.csv", quote = TRUE)


status <- load_sag_status(2022)

write.taf(status, file = "SAG_status_NrS.csv", quote = TRUE)
