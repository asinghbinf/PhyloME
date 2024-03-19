# The purpose of this file is to perform a multiple sequence alignment 

msa_time <- function(seq_type, sequence, msa_type) {
  
  # Perform MSA depending on algorithm type
  
  if (msa_type == "Muscle") {
    msa_complete <- msaMuscle(sequence)
  } else {
    msa_algo <- strsplit(msa_type, "[-]")[[1]][1]
    sub_matrix <- strsplit(msa_type, "[- ]")[[1]][5]
    if (msa_algo == "Clustal W ") {
      msa_complete <- msaClustalW(sequence, substitutionMatrix = sub_matrix)
    } else {
      msa_complete <- msaClustalOmega(sequence, substitutionMatrix = sub_matrix)
    }
  }
  
  return(msa_complete)
  
}