
bootstrap_tree <- function(seq_type, phy, ml_tree, tree_type, bootstrap) {
  
  # Bootstrapping
  if (bootstrap == TRUE) {
    if (tree_type == "Maximum Likelihood") {
      bs_tree <- bootstrap.pml(ml_tree, bs = 10, trees = TRUE, optNni = TRUE)
    } else {
      if (seq_type == "AA") {
        bs_tree <- bootstrap.phyDat(phy, FUN = function(x)NJ(dist.ml(x, model = "JTT")), bs = 2)
      } else {
        bs_tree <- bootstrap.phyDat(phy, FUN = function(x)NJ(dist.ml(x, model = "JC69")), bs = 5)
      }
    }
  }
  
  return(bs_tree)
  
}