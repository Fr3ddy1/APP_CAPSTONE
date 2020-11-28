library(shiny) # load Shiny at the top of both scripts
library(dplyr)
library(DT)


shinyServer(function(input, output) { # define application in here
  
  # uses 'helpfiles' directory by default
  # in this example, we use the withMathJax parameter to render formulae
  observe_helpers(withMathJax = TRUE)
  
  #
  output$word <- renderPrint({
    
    # withProgress(message = 'Loading Data...', value = 1/2, {
    #   #LOAD DATA
    #   # Start the clock!
    #   ptm <- proc.time()
    #   #load("Data/N_grams_10.RData")
    #   #lista <- readRDS(file = "C:/Users/Ecuad/OneDrive/Documentos/CAPSTONE_SPECIALIZATION_ML/DATA_app_10.rds")
    #   # Stop the clock
    #   # #LEO DATA
    #   uni <- fst("Data/uni.fst")
    #   bi <- fst("Data/bi.fst")
    #   tri <- fst("Data/tri.fst")
    #   tetra <- fst("Data/tetra.fst")
    # 
    #   #CONVIERTO A DATA FRAME
    #   unigrama1 <- as.data.frame(uni)
    #   bigram1 <- as.data.frame(bi)
    #   trigrama1 <- as.data.frame(tri)
    #   tetragrama1 <- as.data.frame(tetra)
    # 
    #   print(proc.time() - ptm) #DEMORA  SEG
    # })
    
    return(ls())
  })
  
  #BUTTON
  output$boton1_find <- renderUI({ 
    
    textInput(inputId = "input1_find", label = "Sentence:", value = "") %>%  
      helper(type = "inline",
             title = "Description",
             content = c("Please write a word or sentence to predict the next word"),
             buttonLabel = "Got it!",
             easyClose = FALSE,
             fade = TRUE,
             size = "m")
    
  })
  
  #FUNCTION THAT LOAD THE DATA
  data <- reactive({
    #if (length(which(ls()=="uni"))==0) {
      withProgress(message = 'Loading Data...', value = 1/2, {
        #LEO DATA
        # uni <- fst("Data/uni.fst")
        # bi <- fst("Data/bi.fst")
        # tri <- fst("Data/tri.fst")
        # tetra <- fst("Data/tetra.fst")
        
        # uni <- fst("Data/uni_quan_10.fst")
        # bi <- fst("Data/bi_quan_10.fst")
        # tri <- fst("Data/tri_quan_10.fst")
        # tetra <- fst("Data/tetra_quan_10.fst")
        
        uni <- fst("Data/uni_quan_5.fst")
        bi <- fst("Data/bi_quan_5.fst")
        tri <- fst("Data/tri_quan_5.fst")
        tetra <- fst("Data/tetra_quan_5.fst")
        
        #CONVIERTO A DATA FRAME
        unigrama1 <- as.data.frame(uni)
        bigram1 <- as.data.frame(bi)
        trigrama1 <- as.data.frame(tri)
        tetragrama1 <- as.data.frame(tetra)
        
        return(list(unigrama1,bigram1,trigrama1,tetragrama1))
        
      })#FINAL PROGRESS
    #}# FINAL IF LS
  })
  
  #
  #output$word1 <- renderPrint({
  output$word1 <- renderDT({
    #agrego dependencia 
    input$boton_react_find
    
    unigrama1 <- data()[[1]]
    bigram1 <- data()[[2]]
    trigrama1 <- data()[[3]]
    tetragrama1 <- data()[[4]]
    
    isolate({

      #return(input$input1_find)
      if (length(input$input1_find)!=0) {
        withProgress(message = 'Searching word...', value = 1/2, {
        #return(predict_word(as.character(input$input1_find),unigrama1,bigram1,trigrama1,tetragrama1))
          a <- predict_word(as.character(input$input1_find),unigrama1,bigram1,trigrama1,tetragrama1)
        
          DT::datatable(a,rownames = FALSE,extensions = 'FixedColumns',
                        options = list(
                          scrollX = TRUE,
                          columnDefs = list(list(className = 'dt-center', targets = "_all"))                          
                          ))
          })#FINAL PROGRESS
      }else{
        
      }
      
    }) #FINAL ISOLATE
    
  })
  
  
  
  
  
})