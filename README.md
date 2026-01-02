# InstaAnalyz — Instagram Engagement Analytics Dashboard (R Shiny)

## Project Overview
InstaAnalyz is an interactive R Shiny dashboard for analyzing Instagram post engagement and user interactions. It helps identify engagement patterns, top users, post performance trends, and predicts expected engagement based on posting time, day, and post type using a regression model.

The project uses a simulated Instagram dataset structured to reflect real-world interaction data while maintaining privacy.

---

## Key Features

### Engagement Highlights
- Total number of posts
- Average engagement score
- Most frequent post type
- Most engaged user
- Engagement comparison across post types

### Explore Posts
- Filter posts by date, type (Image, Reel, etc.), and engagement score
- Interactive time-series visualizations
- Dynamic user-level engagement tables

### User Interaction Analysis
- Identify top engaging users
- Sortable and searchable data tables

### Post Performance Insights
- Stacked bar chart of Likes, Comments, Saves across post types
- Post-level engagement breakdown

### Engagement Prediction
- Linear regression model predicts engagement score and expected Likes, Comments, Saves
- Feature impact visualized using model coefficients
- “What-if” analysis for posting strategy optimization

---

## Machine Learning Model
- **Model:** Linear Regression (`lm`)
- **Target Variable:** Engagement Score
- **Features:** Post Type, Hour of Posting, Day of the Week
- Coefficients visualized to interpret feature influence

---

## Tech Stack
- **Language:** R
- **Framework:** R Shiny
- **Libraries:** tidyverse, plotly, DT, lubridate, bslib, broom
- **UI Theme:** Bootstrap (Darkly)
- **Visualization:** Interactive Plotly charts

---

## Project Structure

- **instagram-interaction-analyzer/**
  - `app.R`                  - Shiny dashboard
  - `clean_data.R`           - Data cleaning script
  - `eda.R`                  - Exploratory data analysis
  - `generate_data.R`        - Synthetic dataset generation
  - `instagram_data.csv`     - Simulated Instagram dataset
  - `install_packages.R`     - Script to install dependencies
  - `README.md`              - Project overview


---

## Dataset Details
- Post ID, User ID, Post type, Timestamp
- Likes, Comments, Saves
- Computed engagement score
- Synthetic data simulating real Instagram patterns

---

## Use Cases
- Social media engagement analysis
- Content strategy optimization
- Data visualization and dashboarding
- Portfolio project for data science internships

---

## Future Enhancements
- Deployment on shinyapps.io
- Story and reel-specific analytics
- Follower growth analysis
- Sentiment analysis on comments

---

## Author
**Mallika Mathur**  
Integrated M.Tech — CSE (Data Science)  
Aspiring Data Scientist
