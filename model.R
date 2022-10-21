
# Here we run a few intermediate formatting steps done on SAG. 
# STECF and catch statistics only need one formatting step already done in data.R

library(icesTAF)
library(dplyr)
taf.library(icesFO)

mkdir("model")

clean_sag$MSYBtrigger[which(clean_sag$StockKeyLabel == "ple.27.7e")] <- "0.39"
clean_sag$MSYBtrigger[which(clean_sag$StockKeyLabel == "spr.27.7de")] <- "11527.9"
clean_sag$FMSY[which(clean_sag$StockKeyLabel == "spr.27.7de")] <- "0.0857"

#A. Trends by guild

# clean_sag <- read.taf("data/clean_sag.csv")
trends <- stock_trends(clean_sag)
guild <- guild_trends(clean_sag)

write.taf(trends, dir = "model")
write.taf(guild, dir = "model")

#B.Trends and current catches, landings and discards

catch_trends <- CLD_trends(clean_sag)
catch_current <- stockstatus_CLD_current(clean_sag)

write.taf(catch_trends, dir = "model")
write.taf(catch_current, dir = "model")
