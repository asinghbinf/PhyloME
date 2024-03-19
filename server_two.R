server <- function(input, output, session) {
  
  ## INTRODUCTION ##
  # output$binf <- renderImage({
  #   width <- session$clientData$output_binf_width
  #   height <- session$clientData$output_binf_height
  #   list (
  #     #src = file.path("/Users/anmol/Desktop/CAPSTONE/PhyloME Version 1/www/binf_image.jpg"),
  #     src = file.path("/Users/anmol/Desktop/CAPSTONE/PhyloME Version 1/www/binf_gif.gif"),
  #     contentType = "image/gif",
  #     width = 800,
  #     height = 400, 
  #     align = "center"
  #   )
  # }, deleteFile = F)
  
  ## PIPELINE FOR THE ORIGINAL TREE ## 
  
  # Store sequence type
  sequences <- reactiveValues(seq_one = NULL, seq_two = NULL)
  sequence_types <- reactiveValues(seq_one = NULL, seq_two = NULL)
  my_outgroups <- reactiveValues(outgroups_one = NULL, outgroups_two = NULL)
  final_trees <- reactiveValues(tree_one = NULL, tree_two = NULL)
  
  ## PIPELINE FOR THE ORIGINAL TREE ## 
  
  observe({

    
    req(input$file1)
    
    # Sequence 1
    location_one <- input$file1[[1, "datapath"]]
    data_one <- readLines(location_one)
    seq_one_info <- det_prep_sequence(data_one, location_one)
    sequence_types$seq_one <- seq_one_info[[1]]
    sequence_one <- seq_one_info[[2]]
    sequences$seq_one <- seq_one_info[[2]]
    
    # Count number of files to determine if there is a second sequence 
    list <- input$file1["name"]
    
    # MULTIPLE SEQUENCE ALIGNMENT #

     if (sequence_types$seq_one == "AA") {
       choices <- c("None", "Muscle", "Clustal W - blosum", "Clustal W - pam",
                    "Clustal Omega - BLOSUM30", "Clustal Omega - BLOSUM40", "Clustal Omega - BLOSUM50",
                    "Clustal Omega - BLOSUM65", "Clustal Omega - BLOSUM80", "Clustal Omega - Gonnet")
     } else {
       choices <- c("None", "Muscle", "Clustal W - gonnet", "Clustal W - id", "Clustal Omega - Gonnet")
     }
     
    
     freezeReactiveValue(input, "algo_type_one")
     updateSelectInput(session, "algo_type_one", choice = choices)
    
  })
  
  output$phylo_one <- renderPlot({
    
    # Retrieve information required for tree construction 
      
    # MSA Type
    msa_type <- input$algo_type_one
    
    msa_one <- msa_time(sequence_types$seq_one, sequences$seq_one, msa_type)
    phy <- as.phyDat(msaConvert(msa_one, type = "seqinr::alignment"), type = sequence_types$seq_one)
    
    
    # Distance alignment based on sequence type
    if (sequence_types$seq_one == "AA") {
      distance <- dist.ml(phy, model = "JTT")
    } else {
      distance <- dist.ml(phy, model = "JC69")
    }
    
    # NJ distance method
    og_nj_tree <- phangorn::NJ(distance)
    my_outgroups$outgroups_one <- og_nj_tree
    
    # Tree Type
    tree_type <- input$tree_type_one
    
    # Rooting Type
    root_type <- input$root_type_one
    if (root_type == "Outgroup") {
      outgroup <- input$outgroup_type_one
    } else {
      outgroup <- NULL
    }
    
    # Tree Construction 
    tree_list <- tree_construction(phy, og_nj_tree, tree_type, root_type, outgroup)
    ml_tree <- tree_list[[1]]
    tree <- tree_list[[2]]
    
    if (tree_type == "Maximum Likelihood") {
      tree_nodes <- ml_tree$tree
    } else {
      tree_nodes <- tree
    }
    
    # Bootstrapping 
    bootstrap <- input$bootstrap_switch_one
    if (bootstrap == TRUE) {
      bs_tree <- bootstrap_tree(sequence_types$seq_one, phy, ml_tree, tree_type, bootstrap)
    }
    
    final_tree <- NULL
    
    # Tree Output 
    print_tree <- input$print_tree_one
    options(ignore.negative.edge=TRUE)
    if (print_tree == "Phylogenetic Tree") {
      final_tree <- tree
      plot_tree <- ggplot(tree, aes(x, y)) + geom_tree() + theme_tree() + geom_tiplab() 
    } else {
      final_tree <- bs_tree
      plot_tree <- plotBS(tree_nodes, bs_tree, type = "phylogram")
    }
   
    final_trees$tree_one <- final_tree
    
    return(plot_tree)
    
  })
  
  output$outgroup_one <- renderUI({
    
    selectInput("outgroup_type_one", "Select what species will be the outgroup",
                choices = my_outgroups$outgroups_one$tip.label)
  })
  
  
  
  ## PIPELINE FOR THE SECONDARY TREE ## 
  
  observe({
    
    
    req(input$file2)
    
    # Sequence 1
    location_two <- input$file2[[1, "datapath"]]
    data_two <- readLines(location_two)
    seq_two_info <- det_prep_sequence(data_two, location_two)
    sequence_types$seq_two <- seq_two_info[[1]]
    sequence_two <- seq_two_info[[2]]
    sequences$seq_two <- seq_two_info[[2]]
    
    # Count number of files to determine if there is a second sequence 
    list <- input$file2["name"]
    
    # MULTIPLE SEQUENCE ALIGNMENT #
    
    if (sequence_types$seq_two == "AA") {
      choices <- c("None", "Muscle", "Clustal W - blosum", "Clustal W - pam",
                   "Clustal Omega - BLOSUM30", "Clustal Omega - BLOSUM40", "Clustal Omega - BLOSUM50",
                   "Clustal Omega - BLOSUM65", "Clustal Omega - BLOSUM80", "Clustal Omega - Gonnet")
    } else {
      choices <- c("None", "Muscle", "Clustal W - gonnet", "Clustal W - id", "Clustal Omega - Gonnet")
    }
    
    
    freezeReactiveValue(input, "algo_type_two")
    updateSelectInput(session, "algo_type_two", choice = choices)
    
  })
  
  output$phylo_two <- renderPlot({
    
    # Retrieve information required for tree construction 
    
    # MSA Type
    msa_type <- input$algo_type_two
    
    msa_two <- msa_time(sequence_types$seq_two, sequences$seq_two, msa_type)
    phy <- as.phyDat(msaConvert(msa_two, type = "seqinr::alignment"), type = sequence_types$seq_two)
    
    
    # Distance alignment based on sequence type
    if (sequence_types$seq_two == "AA") {
      distance <- dist.ml(phy, model = "JTT")
    } else {
      distance <- dist.ml(phy, model = "JC69")
    }
    
    # NJ distance method
    og_nj_tree <- phangorn::NJ(distance)
    my_outgroups$outgroups_two <- og_nj_tree
    
    # Tree Type
    tree_type <- input$tree_type_two
    
    # Rooting Type
    root_type <- input$root_type_two
    if (root_type == "Outgroup") {
      outgroup <- input$outgroup_type_two
    } else {
      outgroup <- NULL
    }
    
    # Tree Construction 
    tree_list <- tree_construction(phy, og_nj_tree, tree_type, root_type, outgroup)
    ml_tree <- tree_list[[1]]
    tree <- tree_list[[2]]
    
    if (tree_type == "Maximum Likelihood") {
      tree_nodes <- ml_tree$tree
    } else {
      tree_nodes <- tree
    }
    
    # Bootstrapping 
    bootstrap <- input$bootstrap_switch_two
    if (bootstrap == TRUE) {
      bs_tree <- bootstrap_tree(sequence_types$seq_one, phy, ml_tree, tree_type, bootstrap)
    }
    
    # Tree Output 
    final_tree <- NULL
    
    print_tree <- input$print_tree_two
    options(ignore.negative.edge=TRUE)
    if (print_tree == "Phylogenetic Tree") {
      final_tree <- tree
      plot_tree <- ggplot(tree, aes(x, y)) + geom_tree() + theme_tree() + geom_tiplab() 
    } else {
      final_tree <- bs_tree
      plot_tree <- plotBS(tree_nodes, bs_tree, type = "phylogram")
    }
    
    final_trees$tree_two <- final_tree

    
    return(plot_tree)
    
  })
  
  output$outgroup_two <- renderUI({
    
    selectInput("outgroup_type_two", "Select what species will be the outgroup",
                choices = my_outgroups$outgroups_two$tip.label)
  })
  
  
  output$final_one <- renderPlot({
    
    tree_one <- final_trees$tree_one 
    tree_two <- final_trees$tree_two 
    
    dend_one <- phylogram::as.dendrogram.phylo(tree_one)
    dend_two <- phylogram::as.dendrogram.phylo(tree_two)
    
    off_dend_one <- as.dendrogram(dend_one)
    off_dend_two <- as.dendrogram(dend_two)
    
    display <- input$vis
    
    if (display == "Tanglegram") {
      final_tree <- tanglegram(off_dend_one, off_dend_two) 
      #dendextend::set_labels(final_tree, c("rat", "human"))
      #final_tree %>% set("labels", dendextend::labels) 
      print(off_dend_one %>% labels)
      print(off_dend_two %>% labels)
      print(final_tree %>% labels)
      plot(final_tree, main = "The Tanglegram")
    } else {
      par(mfrow = c(1, 2))
      plot(tree_one, main = "The Original Tree")
      plot(tree_two, main = "The Secondary Tree")
    }
    

    return(tree_one)
    
  })
  
  
 



}

