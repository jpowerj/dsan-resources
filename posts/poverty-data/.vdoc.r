#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| code-fold: true
source("../../_globals.r")
#
#
#
#
#
#
#
#| label: load-poverty-data
#| warning: false
library(tidyverse)
poverty_df <- read_csv("https://raw.githubusercontent.com/light-and-salt/World-Bank-Data-by-Indicators/master/poverty/poverty.csv")
poverty_df |> head()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: extract-below-median
median_df <- poverty_df |> rename(
    below_half_median = `average_value_Proportion of people living below 50 percent of median income (%)`,
    country = `Country Name`
) |> select(country, `Year`, below_half_median)
median_df |> head()
#
#
#
#
#
#| label: compute-country-means
summ_df <- median_df |> group_by(country) |>
  summarize(
    below_half_med_avg = mean(below_half_median),
    year_count = n()
  ) |> drop_na()
summ_df |> head()
#
#
#
#
#
#| label: highest-table
highest_df <- summ_df |>
  arrange(desc(below_half_med_avg)) |>
  head(10) |>
  mutate(category = "highest")
highest_df |> arrange(below_half_med_avg)
#
#
#
#
#
#
#
#| label: highest-plot
# I'm also defining string variables that we can use
# as titles/labels for the remainder of the analysis
title <- "Poverty Rate by Country"
cat_label <- "Country"
rate_label <- "Percent Under 1/2 of Median Income"
highest_df |>
  mutate(country = fct_reorder(country, below_half_med_avg)) |>
  ggplot(aes(y=below_half_med_avg, x=country)) +
  geom_point() +
  geom_segment(aes(xend=country, yend=0)) +
  coord_flip() +
  #theme_classic() +
  theme_jjdsan() +
  labs(title=title, y=rate_label, x=cat_label)
#
#
#
#
#
#| label: lowest-table
lowest_df <- summ_df |>
  arrange(below_half_med_avg) |>
  head(10) |>
  mutate(category = "lowest")
lowest_df
#
#
#
#| label: lowest-plot
lowest_df |>
  mutate(country = fct_reorder(country, below_half_med_avg)) |>
  ggplot(aes(y=below_half_med_avg, x=country)) +
  geom_point() +
  geom_segment(aes(xend=country, yend=0)) +
  coord_flip() +
  #theme_classic() +
  theme_jjdsan()
#
#
#
#
#
high_low_df <- bind_rows(highest_df, lowest_df)
high_low_df |>
  mutate(country = fct_reorder(country, below_half_med_avg)) |>
  ggplot(aes(y=below_half_med_avg, x=country, facet=category)) +
  geom_point() +
  geom_segment(aes(xend=country, yend=0)) +
  coord_flip() +
  #theme_classic() +
  theme_bw()
#
#
#
#
#
#
#
high_low_df |>
  ggplot(aes(y=below_half_med_avg, x=country, color=category)) +
  geom_point() +
  geom_segment(aes(xend=country, yend=0)) +
  coord_flip() +
  #theme_classic() +
  theme_jjdsan()
#
#
#
#
#
#| label: compute-global-median
(global_mean <- mean(summ_df$below_half_med_avg))
#
#
#
high_low_df <- bind_rows(highest_df, lowest_df)
high_low_df |>
  #mutate(country=factor(country, levels=country)) |>
  ggplot(aes(y=below_half_med_avg, x=country, facet=category)) +
  geom_point() +
  geom_segment(aes(xend=country, yend=global_mean)) +
  geom_hline(yintercept=global_mean, linetype="dashed") +
  coord_flip() +
  #theme_classic() +
  theme_jjdsan()
#
#
#
#
