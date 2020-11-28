library(shiny) # load Shiny at the top of both files
library(shinydashboard)
library(DT)

shinyUI(

  #fluidPage(
  dashboardPage(title="Coursera Capstone",
                
                #//////////////#
                #/// HEADER ///#
                #//////////////#
                
                dashboardHeader(title = "Predict Words", titleWidth = 188
                                
                ),#final dashboardheader
                
                #///////////////#
                #/// SIDEBAR ///#
                #///////////////#
                
                dashboardSidebar(
                                 
                                 sidebarMenu(id = "tabs",
                                             
                                             menuItem(tags$span(id="menu1","Welcome"), icon = icon("door-open"),tabName = "section_1"),
                                             menuItem(tags$span(id="menu1","Predict next word"), icon = icon("forward"),tabName = "section_2"),
                                             menuItem(tags$span(id="menu1","About"), icon = icon("info-circle"),tabName = "section_3")
                                             
                                             
        
                                 )#final sidebarmenur
                                 
                ), #final dashboardsidebar
                
                #////////////#
                #/// BODY ///#
                #////////////#
                
                dashboardBody(
                
                tabItems(
                  
                  #//////////////////#
                  #/// BIENVENIDA ///#
                  #//////////////////#
                  
                  
                  tabItem(tabName = "section_1",
                          fluidPage(id="wel",
                                    includeMarkdown("Rmds/Welcome.Rmd")
                          )
                  ),#FINAL TABITEM
                  
                  tabItem(tabName = "section_2",
                          #h3("Section 2"),
                          #verbatimTextOutput("word"),
                          wellPanel( h3("Please, enter a sentence or a word:"),
                       
                                     column(width = 12,
                                            htmlOutput("boton1_find")
                                     ),
                                     #boton q controla la reactividad
                                     actionButton("boton_react_find", "Predict", #icon = icon("chart-area"),
                                                  style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
                          ),#FINAL WELLPANEL
                          #verbatimTextOutput("word1"),
                          DTOutput("word1")
                          
                  ), #FINAL TABITEM
                  
                  tabItem(tabName = "section_3",
                          fluidPage(id="inf",
                                    includeMarkdown("Rmds/info.Rmd")
                          )
                  ) #FINAL TABITEM
                 
                  
                )#final tabitems
                )#final dashboardbody
  )#final dashboardpage
  

)