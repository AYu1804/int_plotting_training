
# CODING SHEET 
# Feel free to follow along the session and fill in this script with code shown by the trainer.
# If at any point you feel lost, you can find the answer code in the "answer_sheet.R" script. 

# Set up ------------------------------------------------------------------

library(tidyverse)
library(plotly)
library(echarts4r)
library(rmarkdown)

# load in COVID-19 case data (available publicly here: https://coronavirus.data.gov.uk/details/download)
cases <- read_csv("covid_data.csv")

# ggplotly example --------------------------------------------------------

plot <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) + 
  geom_point()

ggplotly(plot)

# Single line plot --------------------------------------------------------

cases %>%  
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly() 

# Grouped line plot  ------------------------------------------------------



# Single bar plot ---------------------------------------------------------



# Adding line layer to bar plot -------------------------------------------



# Adding title and tooltip ------------------------------------------------



# Modifying legends -------------------------------------------------------



# Modifying hover text ----------------------------------------------------



# Changing marker colour ---------------------------------------------------



# Editing the modebar -----------------------------------------------------



# refer here for a full list of modebar buttons: https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js

# Exercise 1 --------------------------------------------------------------



# EXTRA: buttons  ---------------------------------------------------------


# EXTRA: dropdowns --------------------------------------------------------

