
# PROBABLY NOT USING THIS - COME BACK IF NECESSARY

library(dplyr)
library(ggplot2)
library(tidyverse)
library(data.table)

# Load the datasets for books and reviews
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

# Print column names for verification
names(books)
names(reviews)

# cleans the Categories column in books
books$Categories <- gsub("[[:punct:]]", "", books$Categories)


merged_data <- inner_join(books, reviews, by = "Title")


categories <- books$Categories
categories <- as.data.table(table(categories)) # Convert to table
popular_categories <- head(categories[order(-N)], 11) # Get top 10 genres
popular_categories <- popular_categories[-1, ] # Remove uncategorized books
popular_categories$categories <- gsub("[[:punct:]]", "", popular_categories$categories) # Remove punctuation
print(popular_categories)


five_s_revs <- merged_data %>% filter(`Review/Score` == 5)
five_s_revs_categs <- as.data.table(table(five_s_revs$Categories)) # Convert to table
setnames(five_s_revs_categs, "V1", "Category") # Rename column
setnames(five_s_revs_categs, "N", "Five_Star_Count") # Rename column
five_s_revs_categs <- head(five_s_revs_categs[order(-Five_Star_Count)], 11) # Get top 50 genres
five_s_revs_categs <- five_s_revs_categs[-2, ] # Remove uncategorized books
print(five_s_revs_categs)


one_s_revs <- merged_data %>% filter(`Review/Score` == 1)
one_s_revs_categs <- as.data.table(table(one_s_revs$Categories)) # Convert to table
setnames(one_s_revs_categs, "V1", "Category") # Rename column
setnames(one_s_revs_categs, "N", "One_Star_Count") # Rename column
one_s_revs_categs <- head(one_s_revs_categs[order(-One_Star_Count)], 11) # Get top 50 genres
one_s_revs_categs <- one_s_revs_categs[-2, ] # Remove uncategorized books
print(one_s_revs_categs)

# Merge 5-star and 1-star counts
merged_counts <- merge(five_s_revs_categs, one_s_revs_categs, by = "Category", all = TRUE)

merged_counts <- merged_counts[order(-merged_counts$Five_Star_Count), ]

merged_counts$Neg_One_Star_Count <- -merged_counts$One_Star_Count

ggplot(data = merged_counts, aes(x = reorder(Category, Five_Star_Count), y = Five_Star_Count)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  geom_bar(aes(y = Neg_One_Star_Count), stat = "identity", fill = "red", alpha = 0.7) +
  coord_flip() +
  labs(
    title = "Comparison of 5-Star and 1-Star Reviews by Category",
    x = "Category",
    y = "Number of Reviews",
    fill = "Review Score"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "none"
  ) +
  scale_y_continuous(
    labels = function(x) ifelse(x < 0, -x, x)
  )
