# Summarize top users by engagement
top_users <- df %>%
  group_by(user_id) %>%
  summarise(total_engagement = sum(engagement_score)) %>%
  arrange(desc(total_engagement)) %>%
  slice_head(n = 10)

# Plot top engagers
ggplot(top_users, aes(x = reorder(user_id, total_engagement), y = total_engagement)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top Engagers",
    x = "User",
    y = "Engagement Score"
  )

# Plot engagement over time
ggplot(df, aes(x = timestamp, y = engagement_score)) +
  geom_line(color = "darkgreen") +
  labs(
    title = "Engagement Over Time",
    x = "Date",
    y = "Engagement Score"
  )