# Load libraries
library("shiny")
library("shinyWidgets")  
library("ape")
library("dendextend")
library("seqinr")
library("Biostrings") 
library("tidyverse") 
library("phangorn") 
library("phytools")
library("msa") 
library("stringr")
library("taxize")
library("ggtree") 
library("ggplot2")
library("shinythemes")
library("dipsaus")
library("phylogram")
library("spiralize")

# Helper functions
source("dp_sequence.R")
source("msa.R")
source("tree_construction.R")
source("bootstrapping.R")

#Sys.setenv(`_R_S3_METHOD_REGISTRATION_NOTE_OVERWRITES_` = "false")

# Retrieve UI and Server files
source("ui_two.R")
source("server_two.R")

# Create shiny app
shinyApp(ui = ui, server = server)

 