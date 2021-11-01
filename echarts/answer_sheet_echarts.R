# ANSWER SHEET 

# Set up ------------------------------------------------------------------

library(tidyverse)
library(plotly)
library(echarts4r)
library(rmarkdown)

cases <- read_csv("covid_data.csv")

# load in fake indicator data
mh <- read_csv("mhtreatment_data.csv")

# Single line plot -------------------------------------------------------

cases %>%  
  filter(areaName == "England") %>% 
  e_charts(x = date) %>% 
  e_line(caseRate)

# Grouped bar plot -------------------------------------------------------

cases %>%  
  group_by(areaName) %>% 
  e_charts(x = date) %>% 
  e_line(caseRate)

# Adding layers -----------------------------------------------------------

cases %>%  
  filter(areaName == "England") %>% 
  e_charts(x = date) %>% 
  e_bar(newCasesByPublishDate) %>% 
  e_line(rollingAvg)
  
# Title, tooltip, legend --------------------------------------------------

#Task: Make an easy-to-read plot showing the number of Male patients in treatment for mental health 
#over time. As a comparison, plot the mean number in treatment last year as an additional line. 

mh %>% 
  filter(Group == "Male") %>% # Male
  e_charts(Date) %>% # over time
  e_line(value) %>%  
  e_tooltip(trigger = "axis") %>%  #tooltip
  e_title("Male patients in treatment for mental health issues") %>%  #add title 
  e_legend(show = FALSE) %>% # remove legend as it's not needed
  e_line(mean, symbol = "none") #add mean line with symbol = "none"

# Using additional arguments from JS  -------------------------------------

mh %>% 
  filter(Group == "Male") %>% 
  e_charts(Date) %>% 
  e_line(value, # within e_line (R equivalent of series: {type:line})
         lineStyle = list( # lineStyle arg. we input a list of additional args WITHIN lineStyle
           color = "#fe213c" # color arg within lineStyle
         )) %>%  
  e_tooltip(trigger = "axis") %>%  #tooltip
  e_title("Male patients in treatment for mental health issues") %>%  
  e_legend(show = FALSE) %>% 
  e_line(mean, symbol = "none") 
  
# Exercise 2 --------------------------------------------------------------

# Using the mh dataset, make an SPC chart (line plot) showing count of male 
# mental health patients in treatment over time. Add an additional line for the 
# mean. Add two additional lines for the upper and lower confidence intervals. 
# Set the tooltip as “axis”.

mh %>% 
  filter(Group == "Male") %>% # filter to male patients
  e_charts(Date) %>%# over time
  e_line(value) %>% # first line layer for values
  e_line(mean, symbol = "none") %>%  # second line layer for mean (without symbols)
  e_line(upper_ci, symbol = "none") %>% # third line for upper CI
  e_line(lower_ci, symbol = "none") %>% # fourth line for lower CI
  e_tooltip(trigger = "axis") 
  
# BONUS 1
# Try adding a scatter layer (e_scatter) for counts that are outside the confidence intervals. 
# These values are kept in the “value_breach” column of the dataset. 
# To make it stand out from the line layer, add “symbolSize = 15” in the function to make it bigger.

mh %>% 
  filter(Group == "Male") %>% 
  e_charts(Date) %>%
  e_line(value) %>% 
  e_line(mean, symbol = "none") %>%  
  e_line(upper_ci, symbol = "none") %>% 
  e_line(lower_ci, symbol = "none") %>% 
  e_scatter(value_breach, symbolSize = 15) %>% # add scatter layer with large symbolSize
  e_tooltip(trigger = "axis") 
  
# BONUS 2 (CHALLENGE)
# By referring to the documentation here: https://echarts.apache.org/en/option.html#series-line.lineStyle.color
# change the upper and lower CI layers to “#d53f58” and the mean layer to “#858585”. 

mh %>% 
  filter(Group == "Male") %>% 
  e_charts(Date) %>%
  e_line(value) %>% 
  e_line(mean, symbol = "none",
         lineStyle = list(color = "#858585")) %>%  # change mean to grey
  e_line(upper_ci, symbol = "none",
         lineStyle = list(color = "#d53f58")) %>% # change upper CI to red
  e_line(lower_ci, symbol = "none",
         lineStyle = list(color = "#d53f58")) %>% # change lower CI to red
  e_scatter(value_breach, symbolSize = 15) %>% 
  e_tooltip(trigger = "axis") 

# EXTRA: Custom themes ----------------------------------------------------

# "westeros" theme
mh %>% 
  filter(Group == "Male") %>% # filter to male patients
  e_charts(Date) %>%# over time
  e_line(value) %>% # first line layer for values
  e_line(mean, symbol = "none") %>%  # second line layer for mean (without symbols)
  e_line(upper_ci, symbol = "none") %>% # third line for upper CI
  e_line(lower_ci, symbol = "none") %>% # fourth line for lower CI
  e_tooltip(trigger = "axis") %>% 
  e_theme("westeros")

# use the custom.json theme provided 
mh %>% 
  filter(Group == "Male") %>% # filter to male patients
  e_charts(Date) %>%# over time
  e_line(value) %>% # first line layer for values
  e_line(mean, symbol = "none") %>%  # second line layer for mean (without symbols)
  e_line(upper_ci, symbol = "none") %>% # third line for upper CI
  e_line(lower_ci, symbol = "none") %>% # fourth line for lower CI
  e_tooltip(trigger = "axis") %>% 
  e_theme_custom("custom.json")

# EXTRA: Connecting two graphs ---------------------------------------------------

# make the plot for male patients:
male <- mh %>% 
  filter(Group == "Male") %>% 
  e_charts(Date) %>% 
  e_line(value) %>%  
  e_tooltip(trigger = "axis") %>%  
  e_title("Male") %>%  
  e_line(mean, symbol = "none") %>% 
  e_group("mh") %>% # to connect them, they need the same group ID
  e_y_axis(max = max(mh$value)) # adjusting the y axis so that it's fixed for both

# make the plot female patients:
female <- mh %>% 
  filter(Group == "Female") %>% #
  e_charts(Date) %>%
  e_line(value) %>%  
  e_tooltip(trigger = "axis") %>%  
  e_title("Female") %>%  
  e_line(mean, symbol = "none") %>% 
  e_group("mh") %>%  # same group ID
  e_y_axis(max = max(mh$value)) %>% 
  e_connect_group("mh") # connect this plot with any plots with the same group ID

# use e_arrange to plot them together
e_arrange(male, female, ncol = 2)

