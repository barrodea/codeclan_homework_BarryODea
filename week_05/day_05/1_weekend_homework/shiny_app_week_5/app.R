library(shiny)
library(tidyverse)
library(shinythemes)

game_sales <- CodeClanData::game_sales

game_sales


# ui ----------------------------------------------------------------------

ui <- fluidPage(
    
    titlePanel(tags$b("Video Games Performance")),
    tags$br(),
    tags$summary("Review of video games and publishers performance 1996 to 2006"),
    tags$br(),
   
    
    theme = shinytheme("slate"),
    
    
    fluidRow(
    tabsetPanel(
        tabPanel("Top 10",
                         
    column(6,plotOutput("top10_plot")),
    
    # this graph is to show the top 10 publishers of games by revenue. It clearly illustrates  that Electonic Art and Nintendo own the greatest market share.
    
    column(6,plotOutput("top10user_plot"))
    
    # this graph is to show the top 10 publishers of games by user review. This shows that the average ratings of the Publisher's games are quite similar. However, its interesting to note that Electronic Arts has one of the lowest ratings despite it having generated the most revenue over the years.
    ),
    
    tabPanel("Publishers and Genre",
   
    selectInput("year_input",
                "Year",
                choices = unique(game_sales$year_of_release)),
             
             
    selectInput("publisher_input",
                "Publisher",
                choices = unique(game_sales$publisher)),
    
    
    fluidRow(
       
        column(6, plotOutput("genre_plot")),
        
        # this plot lets you look at the revenue publishers by genre for a particular year. It gives an insight into what genre is making the most money for each of the publishers. An example would be that fro Nintendo in 2015 shooter games made the most money. The next step would be to look at the trends of each genre over the years on a separate graph.
    
        
        column(6, plotOutput("review_plot")),
        
        # this plot show how the user ratings relate to the critics ratings for each publisher in a particular year. In all of the case I tested there is a strong agreement between both sides in their rating.
    )
    )
        
    )
    )
)


# server ------------------------------------------------------------------

server <- function(input, output) {
    
    output$genre_plot <- renderPlot({
        game_sales %>% 
            filter(publisher == input$publisher_input,
                   year_of_release == input$year_input) %>% 
        ggplot() +
            geom_col(aes(x = genre, y = sales), fill = "#009900") +
            theme_minimal() +
            ggtitle("Revenue per genre") +
            labs(x = "\nGenre",
                 y = "Revenue in 'ms")
    })
    
    
    output$top10user_plot <- renderPlot({
        game_sales %>% 
            group_by(publisher) %>% 
            summarise(user_score = mean(user_score)) %>% 
            slice_max(user_score, n = 10, with_ties = FALSE) %>% 
            ggplot() +
            geom_col(aes(x = publisher, y = user_score), fill = "blue") +
            ggtitle("Top 10 publishers by user review") +
            theme_minimal() +
            scale_y_continuous(breaks = 1:10) +
            labs(x = "\nPublisher",
                 y = "User Review") +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
    })
    
    output$top10_plot <- renderPlot({
        game_sales %>% 
            group_by(publisher) %>% 
            summarise(sales = sum(sales)) %>% 
            slice_max(sales, n = 10) %>% 
            ggplot() +
            geom_col(aes(x = publisher, y = sales), fill = "#009900") +
            theme_minimal() +
            ggtitle("Top 10 publisher by revenue") +
            labs(x = "\nPublisher",
                 y = "Revenue in '000s")+
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
    output$review_plot <- renderPlot({
        game_sales %>% 
            filter(publisher == input$publisher_input) %>% 
            mutate(critic_score = critic_score /10) %>% 
        ggplot() +
            geom_point(aes(x = user_score, y = critic_score), colour = "blue") +
            ggtitle("Comparison of User and Critic Reviews") +
            theme_minimal() +
            labs(x = "\nUser's Reviews",
                 y = "Critic's Reviews\n") +
            scale_x_continuous(breaks = 1:10)
    })
    
    
    }


# shiny app ---------------------------------------------------------------

shinyApp(ui = ui, server = server)
