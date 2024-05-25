
# Our imports
library(dplyr)
library(ggplot2)
library(forcats)
library(tidyr)
library(stringr)
library(tidyverse)
library(data.table)
library(scales)

# Load the datasets for books and reviews - books dataset isnt needed for this operation
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
# books <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

names(reviews)
names(books)

# Count the number of reviews for each book
review_counts <- table(reviews$Title)

# Sort the books based on the number of reviews
most_reviewed_books <- sort(review_counts, decreasing = TRUE)

# Extract the top 10 reviewed books and their review counts
top_books <- names(most_reviewed_books)[1:10]
top_review_counts <- as.numeric(most_reviewed_books[1:10])

top_books_df <- data.frame(Book = top_books, Reviews = top_review_counts)

# Shorten book names after 20 characters
max_length <- 20
top_books_df$Shortened_Book <- ifelse(nchar(top_books_df$Book) > max_length,
                                      substr(top_books_df$Book, 1, max_length) %>% paste0("..."),
                                      top_books_df$Book)

# Create the ggplot bar plot
ggplot(top_books_df, aes(x = Reviews, y = reorder(Shortened_Book, Reviews))) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = Reviews), hjust = -0.2, size = 3) +
  labs(title = "Top 10 Reviewed Books", x = "Number of Reviews", y = "Books") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 9)) +
  theme(axis.text.x = element_text(angle = 35, hjust = 1)) +
  coord_flip()

