# SIMULATED DATA — not real tetanus surveillance.
#
# Fictional jurisdiction: the State of Arcadonia (does not exist).
# Annual tetanus case counts by age group and sex, 2015–2024, used by
# the accessible-branded-documents demo for R/Medicine 2026.

library(tibble)
library(readr)

arcadonia_tetanus <- tribble(
  ~year, ~age_group, ~sex, ~cases,
  2015, "<20",   "M", 1,
  2015, "20–64", "M", 1,
  2015, "≥65",  "F", 1,
  2015, "≥65",  "M", 2,

  2016, "20–64", "F", 1,
  2016, "20–64", "M", 2,
  2016, "≥65",  "F", 1,
  2016, "≥65",  "M", 1,

  2017, "<20",   "F", 1,
  2017, "20–64", "M", 1,
  2017, "≥65",  "F", 1,
  2017, "≥65",  "M", 2,

  2018, "<20",   "M", 1,
  2018, "20–64", "F", 1,
  2018, "20–64", "M", 1,
  2018, "≥65",  "F", 1,
  2018, "≥65",  "M", 1,

  2019, "20–64", "M", 1,
  2019, "≥65",  "F", 1,
  2019, "≥65",  "M", 2,

  2020, "<20",   "M", 1,
  2020, "20–64", "F", 1,
  2020, "20–64", "M", 1,
  2020, "≥65",  "M", 1,

  2021, "20–64", "M", 1,
  2021, "≥65",  "F", 1,
  2021, "≥65",  "M", 2,

  2022, "<20",   "F", 1,
  2022, "20–64", "M", 2,
  2022, "≥65",  "F", 2,
  2022, "≥65",  "M", 2,

  2023, "<20",   "M", 1,
  2023, "20–64", "F", 1,
  2023, "20–64", "M", 1,
  2023, "≥65",  "F", 1,
  2023, "≥65",  "M", 1,

  2024, "<20",   "M", 1,
  2024, "20–64", "F", 1,
  2024, "20–64", "M", 2,
  2024, "≥65",  "F", 1,
  2024, "≥65",  "M", 2,
)

write_csv(arcadonia_tetanus, "data/arcadonia-tetanus.csv")

arcadonia_populations <- tribble(
  ~level,   ~population,
  "<20",     450000,
  "20–64",  1150000,
  "≥65",     400000,
  "F",      1020000,
  "M",       980000
)
write_csv(arcadonia_populations, "data/arcadonia-populations.csv")

message("Wrote ", sum(arcadonia_tetanus$cases), " simulated cases.")
