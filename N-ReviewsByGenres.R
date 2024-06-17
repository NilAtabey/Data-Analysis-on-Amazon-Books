
# Reviews by Genres - Bar Plot of Reviews vs Genres

# Imports
library(ggplot2)
library(data.table)
library(dplyr)

# Load the datasets for books and reviews
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

books$Categories <- gsub("[[:punct:]]", "", books$Categories) # cleaning the categories column - again, this cleaning is specific to our dataset

merged_data <- merge(reviews, books, by.x = "Title", by.y = "Title", all.x = TRUE) # innerjoin by primary key could also be used
rm(reviews) # reviews is a 3GB dataset, removing it after merging both datasets can save some RAM space

book_genres <- unlist(strsplit(merged_data$Categories, ", ")) # extract genres from merged dataset, we could also do this before merging

genre_counts <- table(book_genres) # Count the number of reviews for each genre
genre_counts_df <- data.frame(Genre = names(genre_counts), CommentCount = as.numeric(genre_counts))

top_genres <- head(genre_counts_df[order(-genre_counts_df$CommentCount), ], 10) # sort and select top X, in our case, 10

################################################################################

ggplot(top_genres, aes(x = reorder(Genre, CommentCount), y = CommentCount)) +
  geom_bar(stat = "identity", fill = "darkolivegreen") +
  geom_text(aes(label = comma(CommentCount)), color = "white", vjust = 1.05, hjust = 0.5, size = 2.3) +
  scale_y_continuous(labels = comma) +
  labs(title = "Top Genres Reviewed", x = "Genre", y = "Number of Reviews") +
  theme_gray() +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))

# geom_text was heavily customized, adding digit seperator commas to CommentCount
# was possible by scales::comma, the number of reviews on each bar was added and their
# color, size, vertical and horizontal offsets were optimized.
