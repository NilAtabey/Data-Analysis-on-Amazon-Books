
# Number of Books per Author - Bar Plot of Name of Authors vs Number of Books Published

# Imports
library(ggplot2)
library(data.table)
library(dplyr)

# Load the datasets - reviews dataset isn't needed for this operation
# reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

head(books)
names(books) # check the dataset(s)

books$Authors <- as.character(books$Authors)
books$Publisher <- as.character(books$Publisher)

books <- books[!(is.na(Authors) | Authors == ""), ]
books <- books[!(is.na(Publisher) | Publisher == ""), ] # some independent authors are publishing books by themselves - we get rid of them by eliminating those rows all together since these books tend to be self-released e-books etc.

books$Authors <- gsub("[^a-zA-Z0-9. ]", "", books$Authors) # this cleaning is specific to our dataset - we format author names as normal strings.

head(books) # check the updated dataset

################################################################################

# we also need to filter out authors that appear in the publisher list
# some publishers put their names both in the author section and the publisher section. this function below eliminates an author if the name is ever seen in the publisher column
filter_authors <- function(df) {
  unique_authors <- unique(df$Authors)
  unique_publishers <- unique(df$Publisher)
  
  authors_to_remove <- unique_authors[unique_authors %in% unique_publishers]
  
  df <- df[!(df$Authors %in% authors_to_remove), ]
  return(df)
}
# unfortunately publishers such as "Library of Congress. Copyright Office" still manage to bypass this - since the texts are being published from the office itself, author names aren't mentioned. The author(s) are the office.

books <- filter_authors(books) # apply function to dataset

author_counts <- table(books$Authors)
head(author_counts)

sorted_counts <- as.data.table(author_counts, keep.rownames = "Author")
setnames(sorted_counts, c("Author", "Book_Count"))
sorted_counts <- sorted_counts[order(-Book_Count)] # now we sort

top_authors_table <- sorted_counts[1:15,] # select the top X authors
head(top_authors_table) # double checking

################################################################################

ggplot(top_authors_table, aes(x = reorder(Author, Book_Count), y = Book_Count)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Number of Books Written by Authors",
       x = "Name Of Author",
       y = "Number of Books Published")
