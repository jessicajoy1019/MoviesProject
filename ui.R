library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin = "purple",
    dashboardHeader(title = "Streaming Services"),
    dashboardSidebar(
        
        sidebarUserPanel("Movie Data", image = "https://i.pinimg.com/originals/0b/44/ff/0b44ff30dbe13528285e97eb23b3e185.png"),
        sidebarMenu(
            menuItem("Welcome", tabName = "intro", icon = icon("fas fa-film")),
            menuItem("Ratings", tabName = "rating", icon = icon("fas fa-star-half-alt")),
            menuItem("Map", tabName = "map", icon = icon("fas fa-map-marked-alt")),
            menuItem("Age", tabName = "age", icon = icon("fas fa-birthday-cake")),
            menuItem("Genre", tabName = "genre", icon = icon("fas fa-layer-group")),
            menuItem("Data", tabName = "data", icon = icon("fas fa-table")),
            menuItem("About", tabName = "about", icon = icon("fas fa-address-card")))
    ),
    dashboardBody(
        tags$head(
            tags$style(HTML('.main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 17px;}')),
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = "intro",
                    tabItem(tabName='introduction',
                            HTML('
            <p><center><b><font size="6">Visualizing Streaming Service Data</font></b></center></p>
            <p><center><font size="4">Analyzing movies offered by popular streaming services: Netflix, Hulu, Prime Video, and Disney +</font></center></p>
            <p><center>by Jessica Joy</center></p>
            <p><center>
            The purpose of this project is to help users determine the best streaming service for them based on different preferences.
            <p><center>Several factors are observed including: </center></p>
            <p><center><b><font size="3"> Popular Movie Rating Sites </font></b></center></p>
            <p><center><b><font size="3"> Age-Based Ratings </font></b></center></p> 
            <p><center><b><font size="3"> Country of Production </font></b></center></p>
            <p><center><b><font size="3"> Genre </font></b></center></p>
            
            <p><center> <a href="https://www.kaggle.com/ruchi798/movies-on-netflix-prime-video-hulu-and-disney">Link to Kaggle Data Source</a>
                <br></br> </center></p>
             
            <p><center>
            <img src="https://lh3.googleusercontent.com/proxy/kGvrBCRh-D6WbN19yOkiOeurDFkaTJvSiq5NkRlsggWXRa4GX_d_hepED_WE09MZ9K9iGn7e-0_Wq6sFBZvnNc4mSGaXqVALHA"", height="200px"    
            style="float:center"/></center>
            </p>'
            ))),
            tabItem(tabName = "map",
                    HTML('
            <p><center><b><font size="4">Count of Movies Produced in a Country per Service</font></b></center></p>
            </center></p>'),
                    selectizeInput("Cselected",
                                   "Choose a Service",
                                   countries),
                    fluidRow(box(htmlOutput("map"), width= 800, height = 700)
                             )),
            tabItem(tabName = "rating",
                    HTML('
            <p><center><b><font size="4">Density Plots of Popular Rating Sites</font></b></center></p>
            </center></p>'),
                    plotOutput("rating"), height = 100,
                    plotOutput("imdb"), height= 100),
            tabItem(tabName = "age",
                    selectizeInput("selected",
                                   "Choose a Service",
                                   choice),
                    plotOutput("age"), height = 300),
            
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 20))),
            tabItem(tabName = "genre",
                    HTML('
            <p><center><b><font size="4">Each Platforms Percentage of Movies by Genre</font></b></center></p>
            </center></p>'),
                selectizeInput("Gselected",
                               "Choose a Genre",
                               genre),
                plotOutput("genre"), height = 300),
            tabItem(tabName='about', 
                    fluidRow(
                        column(6,HTML('
                              <p><center><b><font size="4">Jessica Joy</font></b></center></p>
                              <p><center>Recent gradute from Binghamton University with a Bachelor of Science in Financial Economics
                              </center></p>
                              <p><a href="https://www.linkedin.com/in/jessica-joy-128420176/">LinkedIn</a></p>
                              <p><a href="https://github.com/jessicajoy1019/MoviesProject">Github</a></p>
                              <p>E-mail: joyjessica1019@gmail.com</p>
                              <p><br></p>')),
                        column(6,
                               HTML('<img src="https://i.postimg.cc/RZx7xgY2/pic.jpg", height="200px"    
              style="float:right"/>','<p style="color:black"></p>'))
        )
        )
    ))))
