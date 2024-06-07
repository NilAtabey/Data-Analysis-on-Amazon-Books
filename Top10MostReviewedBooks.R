
# Top 10 Most Reviewed Books - Bar Plot of Number of Reviews vs Books(Names)

# Imports
library(dplyr)
library(ggplot2)
library(data.table)

# Load the datasets for books and reviews - books dataset isn't needed for this operation
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
# books <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

names(reviews) # check the dataset

review_counts <- table(reviews$Title) # number of reviews for each book

most_reviewed_books <- sort(review_counts, decreasing = TRUE) # sort review counts

top_books <- names(most_reviewed_books)[1:10] # extract top x, in our case 10
top_review_counts <- as.numeric(most_reviewed_books[1:10])

top_books_df <- data.frame(Book = top_books, Reviews = top_review_counts)


max_length <- 20 # shorten book names after 20 chars for better visualization
top_books_df$Shortened_Book <- ifelse(nchar(top_books_df$Book) > max_length,
                                      substr(top_books_df$Book, 1, max_length) %>% paste0("..."),
                                      top_books_df$Book)

################################################################################

ggplot(top_books_df, aes(x = Reviews, y = reorder(Shortened_Book, Reviews))) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = Reviews), hjust = 0.1, size = 2) +
  labs(title = "Top 10 Most Reviewed Books",
       x = "Number of Reviews",
       y = "Books") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 9)) +
  theme(axis.text.x = element_text(angle = 35, hjust = 1)) +
  coord_flip()

# one cool feature here that enhances visualization is geom_text, we used it to
# make numbers easier to understand (since the numbers are so big)
# we also could decrease the difference in labels of number of reviews (it could
# show points every 2500 reviews instead of every 5000)
