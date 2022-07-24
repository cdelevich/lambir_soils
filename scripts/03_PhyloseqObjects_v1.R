######################
# PHYLOSEQ OBJECTS ###
######################

# This script is part of the Lambir Hills soil fungi project (Malaysia)

# Objectives:
# 1. load in cleaned data files produced from data cleaning script
# 2. 

# [1] LOAD IN DATA TABLES FROM SCRIPT 02 ---------------------------------

meta_table <- read_rds("./data/processed/meta_table.rds") # meta data
asv_table <- read_rds("./data/processed/asv_table.rds") # merged asv table + funguilds

# create a list of our target ecoguilds
ecoguilds <- c("Arbuscular Mycorrhizal","Ectomycorrhizal",
               "Plant Pathogen","Saprotroph")

# [2] CREATE PHYLOSEQ OBJECTS FOR EACH ECOGUILD --------------------------

for (i in ecoguilds) {
}

## do it once, then put it in a loop for each ecoguild

asv_table %>%
  asv_filtered <- filter(EcoGuild == (ecoguilds[1])) # %>% # filter to include one ecoguild
  # seq_matrix <- select(one_of(meta_table$Sample_ID)) # create read matrix with Sample IDs as only columns


#create matrix of sequence read values
seq.matrix_S <- merged %>% 
  select(one_of(as.character(metaS$Sample_ID)))
stopifnot(colnames(seq.matrix_S) == Sample.ID_S)

#drop samples that are outliers in NMDS plot: M3_02
#seq.matrix_S <- select(seq.matrix_S, -c("M3_02"))

#create a matrix of taxa 
taxa_S <- as.matrix(eco.asv_S[,3:8])

#create a data table of sample IDs
Sample.ID.phylo_S <- as.data.frame(Sample.ID_S)
Sample.ID.phylo_S <- Sample.ID.phylo_S %>%
  dplyr::rename(Sample_ID = Sample.ID_S) #%>%
#dplyr::filter(Sample.ID_S != "M3_02")


#create a metadata file physeq object
phy.meta_S  <- merge(Sample.ID.phylo_S,
                     metaS,
                     by = "Sample_ID",
                     sort=F)

#create phyloseq object
OTU_S <- otu_table(seq.matrix_S, taxa_are_rows = TRUE) 
TAX_S <- tax_table(taxa_S)

physeq0_S <- phyloseq(OTU_S, TAX_S)


sampledata_S <- sample_data(data.frame(phy.meta_S,
                                       row.names = sample_names(physeq0_S),
                                       stringsAsFactors = FALSE))
stopifnot(rownames(sampledata_S) == Sample.ID.phylo_S)

#reorder elements that will show up in the NMDS legend
sampledata_S$Soil_type <- factor(sampledata_S$Soil_type, 
                                 levels = c("Upper scarp",
                                            "Clay on shale",
                                            "Sandy clay in valleys",
                                            "Sandy clay loam on ridge"))

#combine phyloseq objects
physeq_S <- phyloseq(OTU_S, TAX_S, sampledata_S)
