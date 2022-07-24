###################
# DATA CLEANING ###
###################

# This script is part of the Lambir Hills soil fungi project (Malaysia)

# Objectives:
# 1. load in sequence read data, metadata, and FUNGuilds data
# 2. clean datasets
# 3. merge FUNGuilds data with the sequence read data
# 4. save clean, merged funguild + asv table and metadata

# [1] LOAD IN DATA --------------------------------------------------------

asv_full <- read.delim("./data/raw/Lambir_ITS_ASVfwd_r121061.txt") # seq reads
meta_full <- read.csv("./data/raw/Lambir_metadata.csv") # metadata
funguilds <- read.delim("./data/raw/Lambir_ITS_ASV_FunGuild_ab.guilds.txt") # FUNGuilds

# [2] CLEAN DATA ----------------------------------------------------------

asv_full <- asv_full %>%
  dplyr::rename(ASV_Seq = otu.X, # rename sequence column [1]
                K2_1020 = K21020) %>% # fix misnamed column in K2
  select(-Kingdom) # all will belong to Kingdom Fungi, don't need

# remove annoying prefixes from the beginning of the taxa names
for (i in 2:7) {
  asv_full[,i] <- sub("...","",asv_full[,i])
}

meta_full <- meta_full %>%
  select(-c(10:28)) #remove nutrient data

funguilds <- funguilds %>%
  dplyr::rename(ASV_Seq = otuID) %>% # rename to match asv_full[1]
  filter(Confidence.Ranking %in% c("Highly Probable","Probable")) %>% # keep only confident matches
  select(c("ASV_Seq","Guild")) # keep only relevant columns
  
# [3] FUNGUILDS MERGE ------------------------------------------------------

# FUNGuilds assigns long strings of ecological guilds, so we want to clean up 
## these assignments to be more concise
funguilds <- funguilds %>% 
  mutate(
    EcoGuild = case_when(
      grepl("-",Guild) ~ "Unclassified",
      grepl("Saprotroph",Guild) ~ "Saprotroph",
      grepl("Animal Endosymbiont",Guild) ~ "Animal Endosymbiont",
      grepl("^Plant Pathogen",Guild) ~ "Plant Pathogen",
      grepl("Lichen",Guild) ~ "Lichen",
      grepl("Endophyte",Guild) ~ "Endophyte",
      grepl("Arbuscular Mycorrhizal",Guild) ~ "Arbuscular Mycorrhizal",
      grepl("Epiphyte",Guild) ~ "Epiphyte",
      grepl("Ericoid Mycorrhizal",Guild) ~ "Ericoid Mycorrhizal",
      grepl("Orchid",Guild) ~ "Ericoid Mycorrhizal",
      grepl("Animal Pathogen",Guild) ~ "Animal Pathogen",
      grepl("Animal Parasite-Fungal Parasite",Guild) ~ "Animal Parasite-Fungal Parasite",
      grepl("Fungal Parasite",Guild) ~ "Fungal Parasite",
      grepl("^Ectomycorrhizal",Guild) ~ "Ectomycorrhizal"
    )
  ) %>%
  select(-Guild) # can now remove Guild, only will use EcoGuilds from here out
funguilds$EcoGuild <- funguilds$EcoGuild %>%
  replace_na("Unclassified") # still remaining NA values, replace

# merge asv table with funguild so we can analyze asvs by ecoguild
funguilds_merged <- merge(funguilds, asv_full, by="ASV_Seq")

# add a unique identifier to each remaining ASV, so when no species or genus ID
## is available we can add the ASV ID to the end
funguilds_merged <- funguilds_merged %>%
  rowid_to_column("ASV_ID") %>%
  select(-ASV_Seq) # no longer need sequence
funguilds_merged$ASV_ID <- paste("ASV",funguilds_merged$ASV_ID, sep = "_")

# [4] SAVE CLEANED FILES ----------------------------------------------------

saveRDS(meta_full, file = "./data/processed/meta_table.rds")
saveRDS(funguilds_merged, file = "./data/processed/asv_table.rds")
