library(DT)
library(shiny)
library(googleVis)
library(tidyverse)
library(dplyr)

shinyServer(function(input, output){
  
  
    # Map
    output$map <- renderGvis({
        gvisGeoChart(cc, locationvar='country', colorvar=input$Cselected,
                     options=list(region='world',backgroundColor='grey', 
                                  colorAxis="{minValue: 0,  colors: ['#EFF5FB', '#0174DF']}",
                                  datalessRegionColor="#FFFFFF", dataMode="markers", 
                                  width="900", height="700"))
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
            theme_void() + ggtitle(paste(input$selected, 'Age-Based Rating Distribution')) +
            theme(plot.title = element_text(hjust = 0.5,face='bold', size=22),
                  legend.title = element_text(hjust = 0.5, face="bold", size = 12)) +
        geom_text(aes(label = paste(round(n / sum(n) * 100, 1), "%"), x = 1.6),
                  position = position_stack(vjust = 0.5)) + 
        scale_fill_manual(values = c("#FE2E2E","#FA8258","#F4FA58", "#81F781","#58ACFA"))
        
    })
    #Rating plots
    output$rating <- renderPlot({
        m %>% ggplot() +
        geom_density(aes(x=`Rotten Tomatoes Score`, color=`Streaming Service`), alpha = 1,size=1.3) + 
        ggtitle('Rotten Tomatoes Rating') +
        theme(plot.title = element_text(hjust = 0.5, face="bold"),
              panel.background = element_blank(),
              panel.grid.major = element_line(colour='lightgrey'), 
              panel.grid.minor = element_line(colour='lightgrey'),
              legend.title = element_text(hjust = 0.5, face="bold", size = 12)) + 
        scale_color_manual(values = c("red","lightgreen","royalblue1", "navyblue")) +
        annotate("rect", xmin = 0, xmax = 60, ymin = 0, ymax = Inf,fill='greenyellow', alpha = 0.17) +
        annotate("rect", xmin = 60, xmax = 100, ymin = 0, ymax = Inf,fill='firebrick1', alpha = 0.17) +
        labs(caption="0% - 60%: Green Splat
             60% - 100% : Red Tomato Score")

    })
    output$imdb <- renderPlot({
        IMDB_ %>% ggplot(aes(x=`IMDb Score`, color=`Streaming Service`)) + 
        geom_density(alpha = 1, size=1.3) + ggtitle('IMDb Rating') +
        theme(plot.title = element_text(hjust = 0.5, face="bold"),
              legend.title = element_text(hjust = 0.5, face="bold", size = 12)) + 
        xlim(0,10) +
        scale_color_manual(values = c("red","lightgreen","royalblue1", "navyblue")) 
      
    })
    
  # Genre plots
    movie_genre_data <- reactive ({
      genremovies %>% 
        filter(get(input$Gselected)==1) %>%
        summarise(Netflix=sum(Netflix=='1'),
                  Hulu=sum(Hulu=='1'),
                  `Prime Video`=sum(`Prime Video`=='1'),
                  `Disney+`=sum(`Disney+`=='1'))%>%
        gather( "Streaming Service", "Count") %>% 
        left_join(totals, by = 'Streaming Service') %>% 
        mutate(Percent = round((Count/Total)*100, 2))
    })    
      output$genre <- renderPlot({
        movie_genre_data() %>% 
        ggplot(aes(`Streaming Service`, Percent, fill = `Streaming Service`)) + 
        geom_bar(stat='identity') +
          scale_fill_manual(values = c("navyblue",
                                       "lightgreen",
                                       "red", "royalblue1")) +
          theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                panel.background = element_blank()) + 
          ggtitle(paste(input$Gselected, "Movies")) +
          theme(plot.title = element_text(hjust = 0.5, face="bold",  size=22),
                legend.title = element_text(hjust = 0.5, face="bold", size = 12))
        
      })     
      
      # DataTable
      output$table <- DT::renderDataTable({
        datatable(movies, rownames=FALSE) 
      })
      

    
    })
