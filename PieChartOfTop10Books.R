
# Our imports
library(dplyr)
library(ggplot2)
library(forcats)
library(tidyr)
library(stringr)
library(tidyverse)
library(data.table)
library(scales)

# Load the datasets for books and reviews
reviews <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

head(books)
head(reviews)

categories <- books$Categories
categories <- as.data.table(table(categories)) # convert to table
popular_categories <- head(categories[order(-N)], 11) # get top 10 genres
popular_categories <- popular_categories[-1,] # get rid of uncategorized books
popular_categories$categories <- gsub("[[:punct:]]", "", popular_categories$categories) # get rid of puncuation
popular_categories
# add "others" as a subtitle

# Calculate percentages
percentages <- percent(popular_categories$N / sum(popular_categories$N))

# Combine labels with percentages
labels_with_percentages <- paste(popular_categories$categories, percentages)


# custom colors
custom_colors <- c("#FF6347", "#4682B4", "#9ACD32", "#FFD700", "#6A5ACD",
                     "#FF69B4", "#8A2BE2", "#40E0D0", "#D2691E", "#7FFF00")


# Create a pie chart
pie(popular_categories$N,
    labels = popular_categories$categories,
    main = "Top 10 Books - Categories Distribution",
    col = custom_colors,
    radius = 1.08)

# Create a pie chart with percentages
pie(popular_categories$N,
    labels = labels_with_percentages,
    main = "Top 10 Books - Categories Distribution",
    col = custom_colors,
    radius = 1.08)


