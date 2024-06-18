
# Distribution of Books by Genres - Pie Chart of Books in Market

# Imports
library(data.table)
library(scales)

# Load the datasets - reviews dataset isn't needed for this operation
# reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

head(books)
names(books) # check the dataset(s)

categories <- books$Categories
categories <- as.data.table(table(categories)) # create seperate categories table
all_categories <- categories[order(-N)]
popular_categories <- head(categories[order(-N)], 11)
popular_categories <- popular_categories[-1,] # get rid of uncategorized books



all$categories <- gsub("[[:punct:]]", "", all$categories)



popular_categories$categories <- gsub("[[:punct:]]", "", popular_categories$categories) # clean the strings

percentages <- percent(popular_categories$N / sum(all_categories$N)) # calculate %'s

custom_colors <- c("#FF6347", "#4682B4", "#9ACD32", "#FFD700", "#6A5ACD",
                     "#FF69B4", "#8A2BE2", "#40E0D0", "#D2691E", "#7FFF00")

par(mar = c(1, 1, 1, 1)) # run this only if Error in plot.new() : figure margins too large

################################################################################

# Create a pie chart
pie(popular_categories$N,
    labels = popular_categories$categories,
    main = "Distribution of Books in the Market based on Genre",
    col = custom_colors,
    radius = 1.08)

# Create a pie chart with percentages
labels_with_percentages <- paste(popular_categories$categories, percentages)

pie(popular_categories$N,
    labels = labels_with_percentages,
    main = "Distribution of Books in Market based on The Top 10 Genres",
    
    col = custom_colors,
    radius = 1.01)
