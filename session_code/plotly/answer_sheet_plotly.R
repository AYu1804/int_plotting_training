
# ANSWER SHEET 

# Set up ------------------------------------------------------------------

library(tidyverse)
library(plotly)

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
  plot_ly(x = ~date, y = ~caseRate, 
          type = 'scatter', mode = "lines") 

# Grouped line plot  ------------------------------------------------------

cases %>%  
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~caseRate, color = ~areaName,
          type = 'scatter', mode = "lines") 


# Single bar plot ---------------------------------------------------------

cases %>%  
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar') 


# Adding line layer to bar plot -------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar', name = "Daily cases") %>% 
  add_trace(y = ~rollingAvg, name = "Rolling avg", type = 'scatter', mode = 'lines')

#NOTE: alternatively, use add_lines to be more specific about the layer you are adding.
#You also won't need to specify type and mode if you use add_lines

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar', name = "Daily cases") %>% 
  add_lines(y = ~rollingAvg, name = "Rolling avg")

# Adding title and tooltip ------------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar', name = "Daily cases") %>% 
  add_lines(y = ~rollingAvg, name = "Rolling avg") %>% 
  layout(title = "Positive cases over time", hovermode = "x unified")

# Modifying legends -------------------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar', name = "Daily cases") %>% 
  add_lines(y = ~rollingAvg, name = "Rolling avg") %>% 
  layout(title = "Positive cases over time", 
         hovermode = "x unified",
         legend = list(orientation = "h",
                       xanchor = "center", 
                       x = 0.5),
         xaxis = list(title = ""))


# Modifying hover text ----------------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar', 
          name = "Daily cases", 
          hovertemplate = "%{y} <b>positive</b> on %{x}") %>% 
  add_lines(y = ~rollingAvg, name = "Rolling avg") %>% 
  layout(title = "Positive cases over time", 
         hovermode = "x unified",
         legend = list(orientation = "h",
                       xanchor = "center", 
                       x = 0.5),
         xaxis = list(title = ""))

# Changing marker colour ---------------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date) %>% 
  add_bars(y = ~newCasesByPublishDate, name = "Daily cases", 
          marker = list(color = "#5694ca")) %>% 
  add_lines(y = ~rollingAvg, name = "Rolling avg", line = list(color = "#003078")) %>% 
  layout(title = "Positive cases over time", 
         hovermode = "x unified",
         legend = list(orientation = "h",
                       xanchor = "center", 
                       x = 0.5),
         xaxis = list(title = ""))


# Editing the modebar -----------------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = 'bar', 
          name = "Daily cases", 
          marker = list(color = "#72ceff")) %>% 
  config(modeBarButtonsToRemove = c("zoomIn2d", "zoomOut2d", "select2d", "lasso2d"))

# refer here for a full list of modebar buttons: https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js

# Exercise 1 --------------------------------------------------------------

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = "bar",
          name = "Cases") %>%  # make base bar plot named “Cases”  
  add_lines(y = ~rollingAvg, type = "scatter", mode = "lines", # add line layer for rolling average
            name = "7-day av", line = list(color = '#003078')) %>%  # name it "7-day av" and change its colour
  layout(title = "Cases by specimen date", # add title
         hovermode = "x unified", # modify tooltip
         legend = list(orientation = "h", # move legend to the bottom
                       xanchor = "center", 
                       x = 0.2),
         xaxis = list(title = ""), # remove x axis title
         yaxis = list(title = "")) # remove y axis title

# EXTRA: buttons  ---------------------------------------------------------

# make buttons using lists. For this example we are using method = "restyle" 
button_list <- list(
  list(
    method = "restyle",
    args = list("type", "bar"),  # first button with label "Bar" that changes type to "bar"
    label = "Bar"
  ),
  list(
    method = "restyle",
    args = list("type", "scatter"), # second button with label "Scatter" that changes type to "scatter"
    label = "Scatter"
  ))

cases %>% 
  filter(areaName == "England") %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = "bar",
          name = "Cases") %>% 
  layout(updatemenus = list( # to add these buttons, use updatemenus arg
    list(
      type = "buttons", 
      y = 0.8,  #placement of buttons on y axis
      buttons = button_list # add in list that we created previously
    )
  ))

# EXTRA: dropdowns --------------------------------------------------------

# make buttons using lists. 
button_list <- list(
  list(
    method = "restyle",
    args = list("transforms[0].value", "England"),  # first button that transforms value to England
    label = "England"
  ),
  list(
    method = "restyle",
    args = list("transforms[0].value", "Hertfordshire"), # first button that transforms value to Hertfordshire
    label = "Herts"
  ))

cases %>% 
  arrange(date) %>% 
  plot_ly(x = ~date, y = ~newCasesByPublishDate, type = "bar",
          name = "Cases",
          transforms = list( # in order to access the "transforms[0].value" attribute, we must make one.
            list(
              type = "filter", # we want it to transform by filtering...
              target = ~areaName, # the areaName variable..
              operator = '=',  # by equaling..
              value = ~c("England", "Hertfordshire")))) %>% # either England or Hertfordshire. 
  layout(updatemenus = list(
    list(type = 'dropdown', # the updatemenus is a dropdown this time
         active = 0, # first option of England by default (javascript starts from 0 not 1)
         buttons = button_list))) # using the button list we made before
