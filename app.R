library(shiny)
library(plotly)
library(DT)
library(tidyverse)
library(lubridate)
library(bslib)
library(broom)

# Load and prepare data
df <- read_csv("C:/Users/dell/Desktop/InstaAnalyz/data/instagram_data.csv") %>%
  mutate(
    weekday = wday(timestamp, label = TRUE),
    hour = as.numeric(hour)
  )

weekday_levels <- levels(df$weekday)

# Fit regression model
model <- lm(engagement_score ~ post_type + hour + weekday, data = df)
model_coefs <- tidy(model)

# Theme
theme <- bs_theme(
  bootswatch = "darkly",
  primary = "#FF2D55",
  font_scale = 1.1,
  base_font = font_google("Nunito")
)

# UI
ui <- fluidPage(
  theme = theme,
  titlePanel("📱 My Insta Dashboard"),
  
  navlistPanel(
    widths = c(2, 10),
    
    tabPanel("🌟 My Highlights",
             fluidRow(
               column(3, tags$div(style = "background-color:#333; color:#FF2D55; padding:10px; border-radius:10px;",
                                  HTML(paste("📸 <b>Total Posts</b><br>", nrow(df))))),
               column(3, tags$div(style = "background-color:#333; color:#20C997; padding:10px; border-radius:10px;",
                                  HTML(paste("📈 <b>Avg Engagement</b><br>", round(mean(df$engagement_score), 1))))),
               column(3, tags$div(style = "background-color:#333; color:#CBAACB; padding:10px; border-radius:10px;",
                                  HTML(paste("🎞️ <b>Top Post Type</b><br>", df %>% count(post_type) %>% arrange(desc(n)) %>% slice(1) %>% pull(post_type)))))
             ),
             br(),
             tags$div(style = "background-color:#222; padding:15px; border-radius:10px; color:white;",
                      HTML(paste("💬 <b>Most Engaged User:</b>", df %>% count(user_id) %>% arrange(desc(n)) %>% slice(1) %>% pull(user_id)))),
             br(),
             plotlyOutput("highlightPlot", height = "300px")
    ),
    
    tabPanel("🔍 Explore My Posts",
             sidebarLayout(
               sidebarPanel(
                 dateRangeInput("date_range", "Pick a Date Range:",
                                start = min(df$timestamp),
                                end = max(df$timestamp)),
                 selectInput("post_type", "Choose Post Type:",
                             choices = unique(df$post_type),
                             selected = "Image"),
                 sliderInput("score_range", "Engagement Level:",
                             min = min(df$engagement_score),
                             max = max(df$engagement_score),
                             value = c(100, 1000))
               ),
               mainPanel(
                 plotlyOutput("engagementPlot", height = "350px"),
                 br(),
                 DTOutput("userTable")
               )
             )
    ),
    
    tabPanel("🧑‍🤝‍🧑 Who Interacts With Me",
             tags$h4("Top Engagers"),
             DTOutput("topEngagers")
    ),
    
    tabPanel("📊 Post Insights",
             fluidRow(
               column(6,
                      plotlyOutput("stackedChart", height = "350px")
               ),
               column(6,
                      DTOutput("postTable")
               )
             )
    ),
    
    tabPanel("📈 What Boosts Your Engagement?",
             fluidRow(
               column(6,
                      plotlyOutput("coefPlot", height = "350px")
               ),
               column(6,
                      tags$h4("Predict Your Post's Engagement"),
                      selectInput("new_type", "Post Type:", choices = unique(df$post_type)),
                      sliderInput("new_hour", "Hour of Posting (0 = midnight, 23 = 11 PM):", min = 0, max = 23, value = 14),
                      selectInput("new_day", "Weekday:", choices = weekday_levels),
                      br(),
                      uiOutput("predictedScore")
               )
             )
    ),
    
    tabPanel("🚧 Coming Soon",
             tags$div("More features like story analysis, follower growth, and DM insights coming soon!", 
                      style = "color:gray; padding:20px; font-style:italic;")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    df %>%
      filter(timestamp >= input$date_range[1],
             timestamp <= input$date_range[2],
             post_type == input$post_type,
             engagement_score >= input$score_range[1],
             engagement_score <= input$score_range[2])
  })
  
  output$highlightPlot <- renderPlotly({
    df %>%
      group_by(post_type) %>%
      summarise(avg_engagement = mean(engagement_score)) %>%
      plot_ly(
        x = ~post_type,
        y = ~avg_engagement,
        type = "bar",
        marker = list(color = c("#FF2D55", "#CBAACB", "#20C997"))
      ) %>%
      layout(title = "Avg Engagement by Post Type",
             plot_bgcolor = "#222", paper_bgcolor = "#222",
             font = list(family = "Nunito", color = "white"))
  })
  
  output$engagementPlot <- renderPlotly({
    plot_ly(
      data = filtered_data(),
      x = ~timestamp,
      y = ~engagement_score,
      text = ~paste("User:", user_id, "<br>Type:", post_type),
      hoverinfo = "text",
      type = "scatter",
      mode = "lines+markers",
      line = list(color = "#FF2D55"),
      marker = list(color = "#FF2D55")
    ) %>%
      layout(title = "Engagement Over Time",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Engagement Level"),
             plot_bgcolor = "#222", paper_bgcolor = "#222",
             font = list(family = "Nunito", color = "white"))
  })
  
  output$userTable <- renderDT({
    filtered_data() %>%
      select(user_id, engagement_score) %>%
      arrange(desc(engagement_score)) %>%
      datatable(options = list(pageLength = 10), class = "table table-dark")
  })
  
  output$topEngagers <- renderDT({
    df %>%
      group_by(user_id) %>%
      summarise(total_engagement = sum(engagement_score)) %>%
      arrange(desc(total_engagement)) %>%
      datatable(options = list(pageLength = 10), class = "table table-dark")
  })
  
  output$postTable <- renderDT({
    df %>%
      select(post_id, post_type, likes, comments, saves, engagement_score) %>%
      arrange(desc(engagement_score)) %>%
      datatable(options = list(pageLength = 10), class = "table table-dark")
  })
  
  output$stackedChart <- renderPlotly({
    df %>%
      group_by(post_type) %>%
      summarise(
        Likes = sum(likes),
        Comments = sum(comments),
        Saves = sum(saves)
      ) %>%
      pivot_longer(cols = c(Likes, Comments, Saves), names_to = "Metric", values_to = "Value") %>%
      plot_ly(
        x = ~post_type,
        y = ~Value,
        color = ~Metric,
        type = "bar"
      ) %>%
      layout(barmode = "stack",
             title = "Total Likes, Comments & Saves by Post Type",
             xaxis = list(title = "Post Type"),
             yaxis = list(title = "Total Count"),
             plot_bgcolor = "#222", paper_bgcolor = "#222",
             font = list(family = "Nunito", color = "white"))
  })
  
  output$coefPlot <- renderPlotly({
    model_coefs %>%
      filter(term != "(Intercept)") %>%
      mutate(term = str_replace(term, "post_type", "Post Type: "),
             term = str_replace(term, "weekday", "Weekday: "),
             term = str_replace(term, "hour", "Hour of Day")) %>%
      plot_ly(
        x = ~term,
        y = ~estimate,
        type = "bar",
        marker = list(color = "#FF2D55")
      ) %>%
      layout(title = "📊 What Boosts Your Engagement?",
             xaxis = list(title = "Feature"),
             yaxis = list(title = "Impact on Score"),
             plot_bgcolor = "#222", paper_bgcolor = "#222",
             font = list(family = "Nunito", color = "white"))
  })
  
  output$predictedScore <- renderUI({
    new_data <- tibble(
      post_type = input$new_type,
      hour = input$new_hour,
      weekday = factor(input$new_day, levels = weekday_levels)
    )
    pred <- predict(model, newdata = new_data)
    
    likes <- round(pred * 0.6)
    comments <- round(pred * 0.25)
    saves <- round(pred * 0.15)
    
    HTML(paste0(
      "<b>📊 Predicted Engagement Score:</b> ", round(pred, 1), "<br>",
      "❤️ <b>Estimated Likes:</b> ", likes, "<br>",
      "💬 <b>Estimated Comments:</b> ", comments, "<br>",
      "💾 <b>Estimated Saves:</b> ", saves, "<br>",
      "🕒 <b>Posted at:</b> ", input$new_hour, ":00 on ", input$new_day, " as a <b>", input$new_type, "</b> post."
    ))
  })
}

# Run the app
shinyApp(ui, server)