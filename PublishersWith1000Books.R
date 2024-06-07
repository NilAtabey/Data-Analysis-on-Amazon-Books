
# Publishers With More Than 1000 Books - Bar Plot of Publishers vs Number of Books

# Imports
library(ggplot2)
library(data.table)

# Load the datasets - reviews dataset isn't needed for this operation
# reviews <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- read.csv("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

head(books)
names(books) # check the dataset(s)

publishers <- books$Publisher # let's seperate publishers
publishers <- as.data.table(table(publishers))
popular_publishers <- subset(publishers, N > 999) # getting rid of the ones with less than X amount of books (in our case, 1k books is the threshold)


popular_publishers <- popular_publishers[-1,] # get rid of uncategorized publishers

# this step is done because we check the popular_publishers table and see that the
# top "publisher" is NA (empty). this is a common issue with a lot of datasets and
# "cleaning" the dataset like this is also apparently referred to as "data wrangling".

popular_publishers # check it out before graphing

################################################################################

ggplot(popular_publishers, aes(x = reorder(publishers, N), y = N)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = N), hjust = 0, size = 2.5) +
  labs(title = "Publishers with More Than 1000 Books On the Market",
       x = "Publishers",
       y = "Number of Books") +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  coord_flip()
