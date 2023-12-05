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
#
#
#
#
#| label: toy-example
#| warning: false
library(tidyverse)
sick_df <- tribble(
    ~Province, ~Total_Population, ~Fever, ~High_Fever, ~Cough,
    "A", 3, 2, 1, 1,
    "B", 4, 1, 1, 2,
    "C", 3, 1, 1, 3,
)
sick_df
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
#| label: toy-micro-1
micro_df_1 <- tribble(
    ~citizen_id, ~Province, ~Fever, ~High_Fever, ~Cough,
    1, 'A', 1, 1, 1,
    2, 'A', 1, 0, 0,
    3, 'A', 0, 0, 0,
    4, 'B', 1, 1, 1,
    5, 'B', 0, 0, 1,
    6, 'B', 0, 0, 0,
    7, 'B', 0, 0, 0,
    8, 'C', 1, 1, 1,
    9, 'C', 0, 0, 1,
    10, 'C', 0, 0, 1
)
micro_df_1
#
#
#
#
#
#
#
#| label: load-data
#| warning: false
library(tidyverse)
macro_df <- read_csv("assets/wild_life_cleaned.csv")
macro_df |> head()
#
#
#
#
#
#| label: long-to-wide
wide_df <- macro_df |>
  select(-c(`IUCN Category`, COU, SPEC)) |>
  pivot_wider(
    names_from = IUCN,
    values_from = Value
  ) |>
  select(-c(THREAT_PERCENT))
wide_df |> head()
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
