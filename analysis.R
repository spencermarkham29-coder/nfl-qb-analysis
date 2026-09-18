install.packages("nflreadr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("readr")

library(nflreadr)
library(dplyr)
library(ggplot2)
library(readr)

qb_data <- load_player_stats(
  seasons = 2025,
  summary_level = "reg"
)

head(qb_data)

names(qb_data)

qb <- qb_data %>%
  filter(position == "QB")

head(qb)

qb <- qb %>%
  filter(attempts >= 200)

qb <- qb %>%
  mutate(
    completion_pct = completions / attempts * 100,
    yards_per_attempt = passing_yards / attempts,
    epa_per_attempt = passing_epa / attempts
  )


qb_summary <- qb %>%
  select(
    player_display_name,
    recent_team,
    attempts,
    completions,
    passing_yards,
    passing_tds,
    passing_interceptions,
    passing_epa,
    completion_pct,
    yards_per_attempt,
    epa_per_attempt
  )

qb_summary

qb_summary %>%
  arrange(desc(epa_per_attempt))

write_csv(
  qb_summary,
  "qb_summary.csv"
)

ggplot(
  qb_summary,
  aes(
    x = passing_yards,
    y = epa_per_attempt
  )
) +
  geom_point() +
  labs(
    title = "Passing Yards vs. EPA per Attempt",
    x = "Passing Yards",
    y = "EPA per Attempt"
  ) +
  theme_minimal()

ggsave(
  "plots/qb_efficiency.png",
  width = 8,
  height = 6
)

