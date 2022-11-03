library(icesTAF)
library(icesFO)
library(dplyr)


out <- load_sag(2022, "Greater North Sea")

#I rescue ank as it has "Replaced" as Purpose (I modify the function)
ank <- load_sag(2022, "Greater North Sea")
ank <- ank %>% filter(FishStock == "ank.27.78abd")

out <- out %>% filter(FishStock != "ank.27.78abd")
out <- rbind(out, ank)

sag_complete <- out

sag_complete <- out
write.taf(out, file = "SAG_complete_NrS.csv", quote = TRUE)


status <- load_sag_status(2022)
#I rescue ank as it has "Replaced" as Purpose (I modify the function)
ank_status <- load_sag_status(2022)
status <- status %>% filter(StockKeyLabel != "ank.27.78abd")

ank_status <- ank_status %>% filter(StockKeyLabel == "ank.27.78abd")

status <- rbind(status, ank_status)

write.taf(status, file = "SAG_status_NrS.csv", quote = TRUE)
