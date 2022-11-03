# Initial formatting of the data

library(icesTAF)
library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")


# 1: ICES official catch statistics

hist <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_2006_2019_catches.csv")
# prelim <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <-
  format_catches(2022, "Greater North Sea",
    hist, official, NULL, species_list, sid)

write.taf(catch_dat, dir = "data", quote = TRUE)


# 2: SAG
sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/data/SAG_data/SAG_status.csv")


#DGS has a custom ref point for F 
sag_complete$FMSY[which(sag_complete$FishStock == "dgs.27.nea")] <- 0.0429543
# sag_complete$MSYBtrigger[which(sag_complete$FishStock == "dgs.27.nea")] <- NA


clean_sag <- format_sag(sag_complete, sid)
clean_status <- format_sag_status(status, 2022, "Greater North Sea")

# clean_sag <- format_sag(sag_sum, sag_refpts, 2021, "Greater North Sea")
# clean_sag <- unique(clean_sag)
# clean_status <- format_sag_status(sag_status, 2021, "Greater North Sea")
# >>>>>>> becf649436a609adb71fbd30c156db050dc615da
# 

write.taf(clean_sag, dir = "data", quote = TRUE)
write.taf(clean_status, dir = "data", quote = TRUE)

# 3: STECF effort and landings

# effort <- read.taf("bootstrap/initial/FDI effort by country.csv", check.names = TRUE)
# names(effort)
# effort$Sub.region <- tolower(effort$Sub.region)
# unique(effort$Sub.region)
# effort_NrS <- dplyr::filter(effort, grepl("27.4.a|27.4.b|27.4.c|27.4.d|27.4.e", Sub.region))


landings1 <- read.taf("bootstrap/initial/Landings_2014.csv", check.names = TRUE)
landings2 <- read.taf("bootstrap/initial/Landings_2015.csv", check.names = TRUE)
landings3 <- read.taf("bootstrap/initial/Landings_2016.csv", check.names = TRUE)
landings4 <- read.taf("bootstrap/initial/Landings_2017.csv", check.names = TRUE)
landings5 <- read.taf("bootstrap/initial/Landings_2018.csv", check.names = TRUE)
landings6 <- read.taf("bootstrap/initial/Landings_2019.csv", check.names = TRUE)
landings7 <- read.taf("bootstrap/initial/Landings_2020.csv", check.names = TRUE)
landings <- rbind(landings1, landings2, landings3, landings4, landings5, landings6, landings7)
names(landings)
landings$Sub.region <- tolower(landings$Sub.region)
landings_NrS <- dplyr::filter(landings, grepl("27.4.a|27.4.b|27.4.c|27.4.d|27.4.e", Sub.region))

# need to group gears, Sarah help.
unique(landings_NrS$Gear.Type)
# unique(effort_NrS$Gear.Type)

landings_NrS <- dplyr::mutate(landings_NrS, gear_class = case_when(
        grepl("TBB", Gear.Type) ~ "Beam trawl",
        grepl("DRB|DRH|HMD", Gear.Type) ~ "Dredge",
        grepl("GNS|GND|GTN|LHP|LLS|FPN|GTR|FYK|LLD|SDN|LTL|LNB", Gear.Type) ~ "Static/Gill net/LL",
        grepl("OTT|OTB|PTB|SSC|SB|SPR|SV", Gear.Type) ~ "Otter trawl/seine",
        grepl("PTM|OTM|PS", Gear.Type) ~ "Pelagic trawl/seine",
        grepl("FPO", Gear.Type) ~ "Pots",
        grepl("NK|NO|LHM", Gear.Type) ~ "other",
        is.na(Gear.Type) ~ "other",
        TRUE ~ "other"
)
)

# effort_NrS <- dplyr::mutate(effort_NrS, gear_class = case_when(
#         grepl("TBB", Gear.Type) ~ "Beam trawl",
#         grepl("DRB|DRH|HMD", Gear.Type) ~ "Dredge",
#         grepl("GNS|GND|GTN|LHP|LLS|FPN|GTR|FYK|LLD|SDN|LTL|LNB", Gear.Type) ~ "Static/Gill net/LL",
#         grepl("OTT|OTB|PTB|SSC|SB|SPR|SV", Gear.Type) ~ "Otter trawl/seine",
#         grepl("PTM|OTM|PS", Gear.Type) ~ "Pelagic trawl/seine",
#         grepl("FPO", Gear.Type) ~ "Pots",
#         grepl("NK|NO|LHM", Gear.Type) ~ "other",
#         is.na(Gear.Type) ~ "other",
#         TRUE ~ "other"
# )
# )

unique(landings_NrS[c("Gear.Type", "gear_class")])
# unique(effort_NrS[c("Gear.Type", "gear_class")])

