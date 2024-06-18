
# Top 10 Most Active Users - Bar Plot of # of Reviews vs User Profile Names

# Imports
library(ggplot2)
library(data.table)
library(scales)

# Load the datasets for books and reviews
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

names(books)
names(reviews)

user_review_counts <- reviews[, .N, by = .(UserID, ProfileName)][order(-N)][2:11] # from 2 because the first "user" is again, unnamed users.
user_review_counts[, ProfileName := sub('".*', '', ProfileName)] # gets rid of user "tags"

head(user_review_counts)
# again, here, with a similar issue (publishers disguised as authors in the books dataset) Midwest Book Review is a group of reviewers
# they likely operate under agreements with Amazon or and satisfy Amazon's guidelines, therefore even if they aren't an "individual user", they are disrupting the data here since they are "legally" allowed.

################################################################################

ggplot(user_review_counts, aes(x = reorder(ProfileName, -N), y = N)) +
  geom_bar(stat = "identity", fill = "salmon") +
  scale_y_continuous(breaks = seq(0, max(user_review_counts$N), by = 1000),
                     labels = comma) +
  geom_text(aes(label = comma(N)), color = "white", vjust = 1.05, hjust = 0.5, size = 2.3) +
  labs(title = "Top 10 Most Active Users", 
       x = "User Profile Names", 
       y = "Number of Reviews") +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))
