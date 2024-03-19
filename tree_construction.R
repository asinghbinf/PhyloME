# The purpose of this file is to construct the tree 

tree_construction <- function(phy, tree, tree_type, root_type, outgroup) {

  tree_nodes <- tree
  ml_tree <- NULL
  
  # Prepare Maximum Likelihood Tree
  if (tree_type == "Maximum Likelihood") {
    
    # Choose best model 
    mt <- modelTest(phy, model = "all", multicore = TRUE, mc.cores = 2)
    lowest <- mt$Model[mt$AIC==min(mt$AIC)]
    mod <- strsplit(lowest, "[+]")[[1]][1]
    mod <- unlist(mod)
    
    # Construct Tree
    ml_tree <- pml(tree, phy, model = mod, k = 4, inv = .2)
    
    # Optimize Tree
    ml_tree <- optim.pml(ml_tree, optNni = TRUE, optBf = TRUE, optQ = TRUE, optInv = TRUE, optGamma = TRUE, optEdge = TRUE)
    
    tree_nodes <- ml_tree$tree
  } 
  
  
  # Retrieve Rooting Style
  root_style <- root_type
  if (root_style == "Outgroup") {
    species <- outgroup
    tree <- root(tree_nodes, species)
  } else if (root_style == "Midpoint") {
    tree <- midpoint(tree_nodes)
  } else {
    tree <- tree_nodes
  }

  tree_list <- list(ml_tree, tree)
  return(tree_list)
}