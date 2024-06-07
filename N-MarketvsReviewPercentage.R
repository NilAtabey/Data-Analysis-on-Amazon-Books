
# Market Distribution vs Review Distribution of Genres

# Imports
library(dplyr)
library(ggplot2)
library(data.table)

# Load the datasets for books and reviews
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

# This part is identical to Market Distribution Pie Chart until the next Chapter

categories <- books$Categories
categories <- as.data.table(table(categories))
all_categories <- categories[order(-N)]
popular_categories <- head(categories[order(-N)], 11)
popular_categories <- popular_categories[-1,] # top 10 genres/categories seperated

all_categories$categories <- gsub("[[:punct:]]", "", all_categories$categories)
popular_categories$categories <- gsub("[[:punct:]]", "", popular_categories$categories) # clean the strings

labels_percentages <- data.table(
  Category = popular_categories$categories,
  MarketPercentage = percent(popular_categories$N / sum(all_categories$N))
)
head(labels_percentages)
books_percentages <- as.data.table(labels_percentages) 

################################################################################

# This section calculates the percentages for the reviews along with the categories of each book that is reviewed.

books$Categories <- gsub("[[:punct:]]", "", books$Categories)
merged_data <- merge(reviews, books, by.x = "Title", by.y = "Title", all.x = TRUE)
book_genres <- unlist(strsplit(merged_data$Categories, ", "))

genre_counts <- table(book_genres, useNA = "ifany")
genre_counts_df <- data.frame(Genre = names(genre_counts), CommentCount = as.numeric(genre_counts))

genre_counts_df <- genre_counts_df[!is.na(genre_counts_df$Genre), ] # filter out NA's

top_genres <- genre_counts_df[order(-genre_counts_df$CommentCount), ] # sort by CommentCount and select top genres

comment_percentages <- data.table(
  Category = top_genres$Genre,
  CommentPercentage = percent(top_genres$CommentCount / sum(top_genres$CommentCount))
)

books_percentages <- as.data.frame(books_percentages)
comment_percentages <- as.data.frame(comment_percentages)
combined_percentages <- merge(books_percentages, comment_percentages, by = "Category", all.x = TRUE) # merge both percentages

colnames(combined_percentages) <- c("Category", "MarketPercentage", "CommentPercentage")
data <- data.frame(combined_percentages)

combined_percentages$MarketPercentage <- as.numeric(gsub("%", "", combined_percentages$MarketPercentage))
combined_percentages$CommentPercentage <- as.numeric(gsub("%", "", combined_percentages$CommentPercentage)) # convert to numeric


combined_percentages <- combined_percentages[order(combined_percentages$MarketPercentage, decreasing = TRUE), ] # order by MarketPercentage

# now we reorder the Category based on the sorted MarketPercentage, this is so that
# the categories appear in the order they appear in Market Distribution, even if
# their reviews percentages are different. data would still be correct but visualization
# would seem "off" if we didn't do this step
combined_percentages$Category <- factor(combined_percentages$Category,
                                        levels = combined_percentages$Category)

combined_all <- melt(combined_percentages, id.vars = 'Category') # combine both data for plottingg

################################################################################

ggplot(combined_all, aes(x = Category, y = value, fill = variable)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  labs(title = 'Comparison of Top Genres: Market vs Review Percentage',
       x = 'Genre', y = 'Percentage') +
  theme(axis.text.x = element_text(angle = 35, hjust = 1, vjust = 1, size = 8)) +
  scale_fill_manual(values = c("MarketPercentage" = "orange",
                               "CommentPercentage" = "skyblue"),
                    labels = c("MarketPercentage" = "Market Percentage",
                               "CommentPercentage" = "Review Percentage")) +
  scale_y_continuous(labels = scales::percent_format(scale = 1))
