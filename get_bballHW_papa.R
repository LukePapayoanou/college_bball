# get_bballHW_papa.R
setwd("/Users/lukepapayoanou/Downloads/Data_330/Data330")

library(readr)
library(stringr)
library(dplyr)
library(lubridate)

url <- "https://kenpom.com/cbbga26.txt"
data <- read_lines(url)

data <- data |> str_match("(\\d{2}\\W{1}\\d{2}\\W{1}\\d{4})\\s(\\D+)\\s*(\\d+)\\s+(\\D+)\\s+(\\d+)") |> data.frame()

data$X3 <- str_trim(data$X3, side = "right")
data$X5 <- str_trim(data$X5, side = "right")
data <- data |> select(-1) |> rename(date = X2, 
                                     away_team = X3,
                                     away_points = X4,
                                     home_team = X5,
                                     home_points = X6)
data$date <- mdy(data$date)
data$away_points <- as.numeric(data$away_points)
data$home_points <- as.numeric(data$home_points)
data <- data |> group_by(date) |> summarise(avg_away_points = round(mean(away_points),2),
                                    avg_home_points = round(mean(home_points),2),
                                    avg_total_points = round(mean(away_points + home_points),2),
                                    amt_games = n())


dir.create("bball", showWarnings = F)

file <- "bball/bballHW_papa.csv"

if(file.exists(file)){
  write_csv(data, file, append = T)
} else {
  write_csv(data, file)
}
