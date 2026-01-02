library(tidyverse)
library(lubridate)

# Load the simulated Instagram data
df <- read_csv("C:/Users/dell/Desktop/InstaAnalyz/data/instagram_data.csv") %>%
  mutate(
    engagement_score = likes + comments + saves,
    weekday = wday(timestamp, label = TRUE),
    hour = sample(0:23, n(), replace = TRUE)  # Simulated hour
  )