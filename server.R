library(DT)
library(shiny)
library(googleVis)
library(tidyverse)

shinyServer(function(input, output){
  
  
  output$intro <- renderText({ input$caption })
  
  
    # Map
    
    country_of_movies <- reactive ({
        countrymovies %>% 
            filter(get(input$Cselected)==1) %>% 
            summarise(N=sum(Netflix=='1'),
                      H=sum(Hulu=='1'),
                      P=sum(`Prime Video`=='1'),
                      D=sum(`Disney+`=='1')) 
        })
    
    output$map <- renderGvis({
        gvisGeoChart(country_of_movies(),
                     options=list(region='world', dataMode="markers", 
                                  width="700", height="700"))
    })
    # DataTable
    output$table <- DT::renderDataTable({
        datatable(movies, rownames=FALSE) 
    })
    
    #Age Distribution
    movie_age_data <- reactive ({
        
        movies %>%
            select(input$selected, Age) %>%
            filter(get(input$selected) == 1,
                   !(Age == "")) %>% 
            group_by(Age) %>%
            summarise(n = n())
        
    })
    
    output$age <- renderPlot({
        movie_age_data() %>%
            ggplot(aes(x="", y=n, fill=Age)) + 
            geom_bar(stat='identity') + 
            coord_polar("y", start=0) +
            theme_void() + ggtitle(paste(input$selected, 'Age Distribution')) +
            theme(plot.title = element_text(hjust = 0.5, size=22))
        
    })
    #Rating plots
    output$rating <- renderPlot({
        m %>% ggplot(aes(x=`Rotten Tomatoes Score`, color=`Streaming Service`)) + 
        geom_density(alpha = 1,size=1.3) + ggtitle('Rotten Tomatoes Rating') +
        theme(plot.title = element_text(hjust = 0.5))
    })
    output$imdb <- renderPlot({
        IMDB_ %>% ggplot(aes(x=`IMDb Score`, color=`Streaming Service`)) + 
        geom_density(alpha = 1, size=1.3) + ggtitle('IMDb Rating') +
        theme(plot.title = element_text(hjust = 0.5)) + xlim(0,10)
      
    })
    
  # Genre plots
    movie_genre_data <- reactive ({
      genremovies %>% 
        filter(get(input$Gselected)==1) %>%
        summarise(Netflix=sum(Netflix=='1'),
                Hulu=sum(Hulu=='1'),
                `Prime Video`=sum(`Prime Video`=='1'),
                `Disney+`=sum(`Disney+`=='1')) %>%
        gather( "Streaming Service", "Count") 
    })    
      output$genre <- renderPlot({
        movie_genre_data() %>% 
        ggplot(aes(`Streaming Service`, Count)) + 
        geom_bar(stat='identity')
        
      })     

    
    })
