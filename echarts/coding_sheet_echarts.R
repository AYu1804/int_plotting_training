
# CODING SHEET 
# Feel free to follow along the session and fill in this script with code shown by the trainer.
# If at any point you feel lost, you can find the answer code in the "answer_sheet.R" script. 

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
  e_charts() 

# Grouped bar plot -------------------------------------------------------



# Adding layers -----------------------------------------------------------



# Title, tooltip, legend --------------------------------------------------

#Task: Make an easy-to-read plot showing the number of Male patients in treatment for mental health 
#over time. As a comparison, plot the mean number in treatment last year as an additional line. 



# Using additional arguments from JS  -------------------------------------



# Exercise 2 --------------------------------------------------------------

# Using the mh dataset, make an SPC chart (line plot) showing count of male 
# mental health patients in treatment over time. Add an additional line for the 
# mean. Add two additional lines for the upper and lower confidence intervals. 
# Set the tooltip as “axis”.



# EXTRA: Custom themes ----------------------------------------------------



# EXTRA: Connecting two graphs ---------------------------------------------------

# make the plot for male patients:



# make the plot female patients:



# use e_arrange to plot them together


