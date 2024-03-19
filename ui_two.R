#https://www.google.ca/url?sa=i&url=https%3A%2F%2Fwallpapercave.com%2Fbioinformatics-wallpapers&psig=AOvVaw3I4GBP1RZs1O5r2kC0qZCF&ust=1680254047911000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOCg1p-og_4CFQAAAAAdAAAAABAD
ui <- navbarPage("PhyloME", theme = shinytheme("yeti"),
                 
                 # # Introduction
                 # tabPanel("Introduction", fluid = TRUE, icon = icon("house"),
                 #          
                 #          tags$head(
                 #            tags$style(
                 #              "
                 #                .title 
                 #                {
                 #                    background:url('https://www.google.ca/url?sa=i&url=https%3A%2F%2Fwallpapercave.com%2Fbioinformatics-wallpapers&psig=AOvVaw3I4GBP1RZs1O5r2kC0qZCF&ust=1680254047911000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCOCg1p-og_4CFQAAAAAdAAAAABAD');
                 #                    background-repeat: no-repeat;
                 #                    background-size: 100%;
                 #                }
                 #                "
                 #            )
                 #          ),
                 #          
                 #          headerPanel(
                 #            h1("PhyloME", class = "title")
                 #            
                 #          ),
                 #          
                 #          
                 #          sidebarLayout(
                 # 
                 #            mainPanel("Main panel")
                 #          )
                 #          
                 #          #tags$style(button_color_css),
                 #          
                 #          # Page Layout
                 #          # mainPanel(
                 #          #   h1("Welcome to PhyloME!", align = "left"),
                 #          #   #setBackgroundImage(src = file.path("/Users/anmol/Desktop/CAPSTONE II/PhyloME Code/www/PhyloME Background.jpeg"), shinydashboard = TRUE)
                 #          #   #imageOutput("binf"),
                 #          #   #p("https://scitechdaily.com/unlimited-possibilities-new-law-of-physics-could-predict-genetic-mutations/", style = "font-size:10px")
                 #          #   img(src = file.path("/Users/anmol/Desktop/CAPSTONE II/PhyloME Code/www/PhyloME Background.jpeg"), shinydashboard = TRUE)
                 #          # )
                 #          
                 # ),
                 
                 # Pipeline
                 tabPanel("The Original Tree", fluid = TRUE, icon = icon("leaf"),
                          #titlePanel("The Pipeline"),
                          
                          tags$style(type="text/css",
                                     ".shiny-output-error { visibility: hidden; }",
                                     ".shiny-output-error:before { visibility: hidden; }"
                          ),
                          
                          h4("Customizing your Phylogenetic Tree"),
                          
                          sidebarLayout(
                            sidebar_content <- sidebarPanel(
                              
                              h5("Step 1: File Upload"),
                              fileInput("file1", "Choose Your File",
                                        multiple = TRUE),
                              
                              tags$hr(),
                              
                              h5("Step 2: Multiple Sequence Alignment"),
                              
                              selectInput("algo_type_one", label = "Select your Multiple Sequence Alignment Choice",
                                          character(0)),
                              
                              h5("Step 3: Constructing the Tree"),
                              # Select tree construction type
                              radioButtons("tree_type_one", "Select your tree construction type",
                                           choices = list("Neighbour Joining", "Maximum Likelihood"),
                                           selected = NULL),
                              
                              # Select tree rooting type
                              radioButtons("root_type_one", "Select your rooting style",
                                           choices = list("Unrooted", "Midpoint", "Outgroup"),
                                           selected = NULL),
                              
                              # Selecting outgroup
                              uiOutput("outgroup_one"),
                              
                              # Bootstrapping
                              materialSwitch("bootstrap_switch_one",
                                             label = "Bootstrap Tree",
                                             value = FALSE,
                                             status = "success"),
                              
                              tags$hr(),
                              h5("Step 4: Select Your Tree"),
                              radioButtons("print_tree_one", "Select which tree(s) you would like to display",
                                           choices = list("Phylogenetic Tree", "Bootstrapped Phylogenetic Tree")),
                              
                              
                            ),
                            
                            mainPanel(
                              
                              plotOutput("phylo_one")
                            )
                            
                          
                          # sidebar layout bracket  
                          )
                          
              # tab panel bracket   
              ),
              
              
              tabPanel("The Secondary Tree", fluid = TRUE, icon = icon("seedling"),
                       
                       tags$style(type="text/css",
                                  ".shiny-output-error { visibility: hidden; }",
                                  ".shiny-output-error:before { visibility: hidden; }"
                       ),
                       

                       h4("Customizing your Phylogenetic Tree"),

                       sidebarLayout(
                         sidebar_content <- sidebarPanel(

                           h5("Step 1: File Upload"),
                           fileInput("file2", "Choose Your File",
                                     multiple = TRUE),

                           tags$hr(),

                           h5("Step 2: Multiple Sequence Alignment"),

                           selectInput("algo_type_two", label = "Select your Multiple Sequence Alignment Choice",
                                       character(0)),

                           h5("Step 3: Constructing the Tree"),
                           # Select tree construction type
                           radioButtons("tree_type_two", "Select your tree construction type",
                                        choices = list("Neighbour Joining", "Maximum Likelihood"),
                                        selected = NULL),

                           # Select tree rooting type
                           radioButtons("root_type_two", "Select your rooting style",
                                        choices = list("Unrooted", "Midpoint", "Outgroup"),
                                        selected = NULL),

                           # Selecting outgroup
                           uiOutput("outgroup_two"),

                           # Bootstrapping
                           materialSwitch("bootstrap_switch_two",
                                          label = "Bootstrap Tree",
                                          value = FALSE,
                                          status = "success"),

                           tags$hr(),
                           h5("Step 4: Select Your Tree"),
                           radioButtons("print_tree_two", "Select which tree(s) you would like to display",
                                        choices = list("Phylogenetic Tree", "Bootstrapped Phylogenetic Tree")),


                         ),

                         mainPanel(

                           plotOutput("phylo_two")
                         )
                  )

              ),
              
              tabPanel("Visualization", fluid = TRUE, icon = icon("tree"),
                       
                       tags$style(type="text/css",
                                  ".shiny-output-error { visibility: hidden; }",
                                  ".shiny-output-error:before { visibility: hidden; }"
                       ),
                       
                       
                       h4("Visualizing your Phylogenetic Tree"),
                       
                       sidebarLayout(
                         sidebar_content <- sidebarPanel(
                           
                           h5("Step 1: Select Tree Visualization Type"),
                           # Select tree visualization type
                           radioButtons("vis", "Select your tree visualization type",
                                        choices = list("Individual", "Tanglegram"),
                                        selected = NULL),
                           
                         
                         tags$hr(),
                         
                         h5("Step 2: Download "),
                         # Select download type
                         checkboxGroupInput("download", "Select which format you would like to download your file in",
                                      choices = list("PDF", "Nexus File", "Newick File"),
                                      selected = NULL),
                         
                         ),
                         
                         mainPanel(
                           
                           #verbatimTextOutput("final_one"),
                           plotOutput("final_one")
                           
                         )
                      )
              )
)