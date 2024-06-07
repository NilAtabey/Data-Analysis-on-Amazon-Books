
# Percentage Distribution of All Ratings - Percentage vs Score Given (in stars)

# Imports
library(ggplot2)
library(data.table)
library(dplyr)

# Load the datasets for books and reviews
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

books$Categories <- gsub("[[:punct:]]", "", books$Categories) # cleaning the categories column - again, this cleaning is specific to our dataset

merged_data <- inner_join(books, reviews, by = "Title") # join both datasets by the primary key

# We can calculate the overall distribution of all review scores from 1-5 using the dplyr package. 
overall_distribution <- merged_data %>%
  group_by(`Review/Score`) %>% # helps perform any operation “by group”
  summarise(Count = n()) %>% # reduces multiple values down to a single summary
  mutate(Percentage = Count / sum(Count) * 100) # adds new variables that are functions of existing variables

################################################################################

ggplot(overall_distribution, aes(x = factor(`Review/Score`), y = Percentage, fill = factor(`Review/Score`))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     breaks = seq(0, 100, by = 10)) +
  scale_fill_manual(values = c("1" = "#e40042",
                               "2" = "#fe8100",
                               "3" = "#ffd800",
                               "4" = "#8acd01",
                               "5" = "#009d00")) +
  labs(
    title = "Book Review Ratings Breakdown",
    x = "Review Score Given (in stars)",
    y = "Percentage of Reviews",
    fill = "Review Score Given"
  ) +
  theme_minimal()

# scale_y_continuous ensures that the y-axis displays values as percentages
# and sets the axis ticks at every 10% interval
