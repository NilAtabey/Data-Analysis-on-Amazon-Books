
# User Network by their Reviews - By Thickness of Connection

# Imports
library(dplyr)
library(ggplot2)
library(data.table)
library(reshape2)
library(igraph)

# Load the datasets for books and reviews
reviews <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/reviews_data_modified.csv")
books <- fread("C:/Users/Nil Atabey/Desktop/DMA2-NOTES/DMA-PROJECT-FOLDER/books_data_modified.csv")

################################################################################

dupe_user_review_counts <- reviews[, .N, by = .(UserID, ProfileName)][order(-N)][3:12] # Get the top X users based on the number of reviews from 2 if we want to get rid NA, from 3 if we want to get rid of Midwest Book Reviews too

dupe_user_review_counts[, ProfileName := sub('".*', '', ProfileName)] # string cleaning

top_users_reviews <- reviews[UserID %in% dupe_user_review_counts$UserID] # get rid of unnecessary columns

user_pairs <- combn(dupe_user_review_counts$UserID, 2, simplify = FALSE) # create an edge list for the network graph (shared books between users)

edge_list <- data.table(User1 = character(), User2 = character(), weight = integer()) # initialize an empty data table for edges, will make sense later on

################################################################################

# create function to create said edges
for (pair in user_pairs) {
  user1_reviews <- top_users_reviews[UserID == pair[1], ID]
  user2_reviews <- top_users_reviews[UserID == pair[2], ID] # get the id's of reviews made by the first and the second user in the pair
  shared_reviews <- intersect(user1_reviews, user2_reviews) # find common reviews between them
  
  if (length(shared_reviews) > 0) { # if there are any shared reviews between the two users
    edge_list <- rbind(edge_list, data.table(User1 = pair[1],
                                             User2 = pair[2],
                                             weight = length(shared_reviews))) # add to edge
  }
}

################################################################################

edge_list[, weight := weight / max(weight) * 6] # better visualization, adjusting the thickness of lines

# create graph and modify colors etc.
g <- graph_from_data_frame(d = edge_list, directed = FALSE)
V(g)$label <- dupe_user_review_counts$ProfileName[match(V(g)$name,
                                                        dupe_user_review_counts$UserID)]
V(g)$color <- "cyan"

plot(g,
     vertex.label.cex = 0.7,
     vertex.size = 15,
     edge.arrow.size = 0.4, 
     layout = layout_with_fr,
     main = "Network of Top 10 Users and Shared Book Reviews",
     edge.width = E(g)$weight)
