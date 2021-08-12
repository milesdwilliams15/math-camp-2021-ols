####################################
# Create cleaned data for exercise
####################################

library(tidyverse)

# Penn data
pwt <- pwt9::pwt9.1 %>%
  filter(year %in% 2017) %>%
  select(country, year, pop, rgdpna, hc) %>%
  mutate(code = countrycode::countrycode(country, "country.name", "iso3c"))

# Polity data
pty <- democracyData::polityIV %>%
  filter(year %in% 2017) %>%
  select(polityIV_country, year, polity2) %>%
  rename(country = polityIV_country) %>%
  mutate(code = countrycode::countrycode(country, "country.name", "iso3c"))

# Merge
ds <- inner_join(
  pwt, pty,
  by = c("year", "code")
) %>%
  select(-country.y) %>%
  rename(country = country.x,
         population = pop,
         gdp = rgdpna,
         human_capital = hc,
         polity = polity2) %>%
  select(code, everything()) %>%
  na.omit %>%
  mutate(population = log(population),
         gdp = log(gdp))

# Write CSV
write_csv(
  ds, file = "01_data/data.csv"
)
