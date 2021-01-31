library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin = "purple",
    dashboardHeader(title = "Streaming Services"),
    dashboardSidebar(
        
        sidebarUserPanel("Movies", image = "https://lh3.googleusercontent.com/proxy/Gjkep2gC3T8rBCBjU079ofXZ4Q6iK4OFhS2VXbUzrVEHd7MUpPFDQO9vFaA-JB4xB40zWwbvINackP7kXHB-K_0"),
        sidebarMenu(
            menuItem("Welcome", tabName = "intro", icon = icon("fas fa-film")),
            menuItem("Ratings", tabName = "rating", icon = icon("database")),
            menuItem("Map", tabName = "map", icon = icon("fas fa-map-marked-alt")),
            menuItem("Age", tabName = "age", icon = icon("database")),
            menuItem("Genre", tabName = "genre", icon = icon("database")),
            menuItem("Data", tabName = "data", icon = icon("database"))
        )
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
                    fluidPage(
                        textInput("caption", "Welcome", "Streaming Services"),
                        verbatimTextOutput("value"))),
            tabItem(tabName = "map",
                    selectizeInput("Cselected",
                                   "Select Country",
                                   countries),
                    fluidRow(box(htmlOutput("map"), height = 700)
                             )),
            tabItem(tabName = "rating",
                    plotOutput("rating"), height = 100,
                    plotOutput("imdb"), height= 100),
            tabItem(tabName = "age",
                    selectizeInput("selected",
                                   "Choose a Service",
                                   choice),
                    plotOutput("age"), height = 300),
            
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))),
            tabItem(tabName = "genre",
                selectizeInput("Gselected",
                               "Choose a Genre",
                               genre),
                plotOutput("genre"), height = 300)
        ),
        )
    ))