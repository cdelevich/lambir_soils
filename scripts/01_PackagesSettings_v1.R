#########################
# PACKAGES + SETTINGS ###
#########################

# This script is part of the Lambir Hills soil fungi project (Malaysia)

# Objectives:
# 1. load required packages
# 2. set colors for all figures

# [1] PACKAGES -----------------------------------------------------

packages <- c("tidyverse","phyloseq","ggpubr","vegan","knitr",
              "kableExtra","pairwiseAdonis","indicspecies","FSA",
              "reshape2","stringr","GGally")
lapply(packages, require, character.only = TRUE)


# [2] FIGURE COLORS ------------------------------------------------

# Fig. 1 - Relative Abundance of EcoGuilds
colors12 <- c("#985ed1","#ff9d7c","#2E5984","#620058","#b8a332",
              "#6875cd","#b24916","#5a6e49","#ff5125","#4aaa86",
              "#c45d85","#999999")

# Fig. 2 - Top 10 Most Abundant Families per EcoGuild
# arbuscular mycorrhizal fungi
colors10_am <- c("#9d9ec3","#8dd155","#904cce","#cba755","#4e4081",
                 "#89ceb2","#c95692","#516941","#c8543c","#5c3638")
# ectomycorrhizal fungi
colors10_em <- c("#9d9ec3","#8dd155","#904cce","#cba755","#4e4081",
                 "#89ceb2","#c95692","#516941","#c8543c","#5c3638")
# plant pathogenic fungi
colors10_pp <- c("#ff82bb","#add435","#314ace","#c05f00","#007abb",
                 "#b70065","#007862","#cda5cb","#655673","#653c9f")
# saprotrophic fungi
colors10_sa <- c("#664091","#00d472","#bb0087","#286300","#a287ff",
                 "#c27200","#01b3ff","#fb4842","#843f14","#ff8e9c")

# Fig. 3_1 - NMDS by Soil Type
colors4_soiltype <- c("#893101","#040273","#73A5C6","#ED7117")

# Fig. 3_2 - NMDS by Soil Horizon
# with litter
colors4_soilhorizon <- c('#518D6A','#D2B48C','#987554','#310A0B')
# without litter
colors3_soilhorizon <- c('#D2B48C','#987554','#310A0B')
