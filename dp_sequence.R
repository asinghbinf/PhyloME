## Purpose
# The purpose of this file is to determine the sequence type (DNA, RNA, or amino acid) 
# The file will also prepare the sequence for the MSA 

# Function to check sequence type 
det_prep_sequence <- function(data_file, location) {
  
  # Determine Sequence #
  
  # Clean data to remove headers 
  data <- str_to_upper(data_file[-which(str_detect(data_file, ">"))])
  
  # Convert string to vector 
  data <- unlist(str_split(data, ""))
  
  # Unique letters to determine sequences 
  unique_AA <- c('R', 'N', 'D', 'Q', 'E', 'H', 'I', 'L', 'K', 'M', 'F', 'P', 'O', 'S', 'W', 'Y', 'V', 'B', 'Z', 'X', 'J')
  unique_DNA <- 'T'
  unique_RNA <- 'U'
  
  # Determine what type of sequence 
  det <- length(which(unique_AA%in%unlist(str_split(data, ""))))
  if (det > 0) {
    seq_type <- "AA"
  } else {
    det <- length(which(unique_DNA%in%unlist(str_split(data, ""))))
    if (det > 0) {
      seq_type <- "DNA"
    } else {
      seq_type <- "RNA"
    }
  }
  
  # Prepare sequence for alignment #
  
  # Clean names 
  if (seq_type == "AA") {
    sequence <- readAAStringSet(filepath = location)
    names(sequence) <- str_remove_all(str_split_fixed(names(sequence), pattern = "\\[", n=2)[,2], "\\]")
  } else if (seq_type == "RNA") {
    RNA_string <- readRNAStringSet(filepath = location)
    sequence <- RNA2DNA(RNA_string)
    names(sequence) <- apply(str_split_fixed(names(sequence), pattern = " ",4)[,2:3], 1, base::paste, collapse = " ")
    seq_type == "DNA"
  } else {
    sequence <- readDNAStringSet(filepath = location)
    names(sequence) <- apply(str_split_fixed(names(sequence), pattern = " ",4)[,2:3], 1, base::paste, collapse = " ")
  }
  
  seq_list <- list(seq_type, sequence)
  
  return(seq_list)
  
} 

#location <- "/Users/anmol/Desktop/CAPSTONE II/Files/TP53.fasta"
#data <- readLines(location)

