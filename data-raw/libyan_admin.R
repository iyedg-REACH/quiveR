library(dplyr)
library(magrittr)
library(here)
library(readr)

admin_codes <- read_csv("data-raw/lby_pcodes_kobo.csv", show_col_types = FALSE) %>%
  janitor::clean_names()

######### Regions
lby_regions <- admin_codes %>%
  filter(list_name == "Region") %>%
  rename(
    region_id = name,
    region_name_en = label_english,
    region_name_ar = label_arabic
  ) %>%
  mutate(
    across(.fns = stringr::str_squish)
  ) %>%
  janitor::remove_empty(which = "cols") %>%
  select(-list_name)

usethis::use_data(lby_regions, overwrite = TRUE)


######### Districts
lby_districts <- admin_codes %>%
  filter(list_name == "District") %>%
  rename(
    region_id = region,
    district_id = name,
    district_name_en = label_english,
    district_name_ar = label_arabic
  ) %>%
  mutate(
    across(.fns = stringr::str_squish)
  ) %>%
  janitor::remove_empty(which = "cols") %>%
  relocate(region_id, .before = district_id) %>%
  select(-list_name)

usethis::use_data(lby_districts, overwrite = TRUE)

######### Municipalities
lby_municipalities <- admin_codes %>%
  filter(list_name == "Municipality") %>%
  rename(
    region_id = region,
    district_id = district,
    municipality_id = name,
    municipality_name_en = label_english,
    municipality_name_ar = label_arabic
  ) %>%
  mutate(
    across(.fns = stringr::str_squish)
  ) %>%
  janitor::remove_empty(which = "cols") %>%
  relocate(district_id, .before = municipality_id) %>%
  relocate(region_id, .before = district_id) %>%
  select(-list_name)

usethis::use_data(lby_municipalities, overwrite = TRUE)
