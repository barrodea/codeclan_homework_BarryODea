library(shiny)
library(tidyverse)
library(CodeClanData)
library(shinythemes)

olympics_overall_medals <- olympics_overall_medals

# ui ----------------------------------------------------------------------


ui <- fluidPage(
    theme = shinytheme("darkly"),
    
    titlePanel(tags$b("Five Country Medal Comparison")),
    tags$br(),
    tags$blockquote("It’s not about winning at the Olympic Games. It’s about trying to win. The motto is faster, higher, stronger, not fastest, highest, strongest. Sometimes it’s the trying that matters.", cite = "Bronte Barratt"),
    
    tabsetPanel(
        tabPanel("Plot", plotOutput("medal_plot")),
        
        
        tabPanel("Website",
                 tags$a("The Olympics website", href = "https://www.Olympic.org/"))
    ), 
    fluidRow(
        column(6,
            
            radioButtons("season_input",
                         tags$i("Summer or Winter Olympics?"),
                         choices = c("Summer", "Winter")
            )
            ),

        column(6,   
        
        selectInput("medal_input",
                     tags$i("Which medal?"),
                     choices = c("Gold", "Silver", "Bronze")
        ),
        )
        )
   
    )


# server ------------------------------------------------------------------


server <- function(input, output) {
    output$medal_plot <- renderPlot({
 
    olympics_overall_medals %>%
        filter(team %in% c("United States",
                           "Soviet Union",
                           "Germany",
                           "Italy",
                           "Great Britain")) %>%
        filter(medal == input$medal_input) %>%
        filter(season == input$season_input) %>%
        ggplot() +
        aes(x = team, y = count, fill = medal) +
        geom_col() +
        scale_fill_manual(values = c("Gold" = "#ffdd1a", "Silver" = "#d9d9d9", "Bronze" = "#d99f0d"))
        
    }
    )    
}

shinyApp(ui = ui, server = server)