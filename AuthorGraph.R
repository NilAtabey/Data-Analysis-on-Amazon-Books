setwd("C:/Users/julio/Dropbox/PC/Desktop/Books/")

ratings <- data.table::fread("reviews_data_modified.csv")
books <- data.table::fread("books_data_modified.csv")

categories <- as.data.table(table(categories))

head(books)
head(ratings)
titleAuthor <- cbind(books$Title, books$Authors)
colnames(titleAuthor) <- c("Title", "Authors")

titleScore <- cbind(Title=ratings$Title, Score=ratings$`Review/Score`)
titleAuthScore <- merge(titleAuthor, titleScore, by="Title")
head(titleAuthScore)

library(dplyr)

authorsReviewCounts <- table(titleAuthScore$Authors)
authorsReviewCounts <- authorsReviewCounts  %>% 
  as.data.frame() 

#Star Graph Pipeline
library(igraph)
tolkienReviews <- titleAuthScore[(titleAuthScore$Authors == "['J. R. R. Tolkien']") | (titleAuthScore$Authors == "['John Ronald Reuel Tolkien']"),]
booksReviewsCount <- as.data.frame(table(tolkienReviews$Title))
booksAverageScores <- tolkienReviews %>%
                      group_by(Title) %>%
                      summarize(MeanScore = mean(as.numeric(Score)))
vertices <- c("J.R.R. Tolkien", booksAverageScores$Title)
adj_matrix <- matrix(0, nrow= length(vertices), ncol= length(vertices))
rownames(adj_matrix) = vertices
colnames(adj_matrix) = vertices
adj_matrix[1, ] = 1
adj_matrix[, 1] = 1
adj_matrix[1, 1] = 0
color.gradient <- function(x, colors=c("tomato", "gold", "seagreen1"), 
                           colsteps=10) {
  return(colorRampPalette(colors)(colsteps)[
    findInterval(x, seq(min(x), max(x), length.out=colsteps))
  ])
}
g <- graph_from_adjacency_matrix(adj_matrix, mode="undirected")
V(g)$ReviewCount <- c(0, booksReviewsCount$Freq)
V(g)$AverageScores <- c(0, booksAverageScores$MeanScore)
V(g)$size <- (log(V(g)$ReviewCount) ** 1.3) * 2
V(g)$size[1] <- 45
V(g)[ReviewCount < 2000 & ReviewCount > 0]$name = NA
V(g)$color <- color.gradient(V(g)$AverageScores)
V(g)[1]$color <- "deepskyblue"
library(stringr)
V(g)$name <- str_trunc(V(g)$name, width= 30)
V(g)$label.cex = V(g)$size/25
V(g)[1]$label.cex = .7
V(g)$label.color = "slateblue4"
V(g)[1]$label.color = "black"
V(g)$shape = "circle"
V(g)[1]$shape = "rectangle"
V(g)$label.font = 1
V(g)[1]$label.font = 2

plot(g, margin=-0.1)
