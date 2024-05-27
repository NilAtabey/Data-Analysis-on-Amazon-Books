setwd("C:/Users/julio/Dropbox/PC/Desktop/Books/")

ratings <- data.table::fread("reviews_data_modified.csv")

titleReview <- cbind(ratings$Title, ratings$`Review/Score`)
colnames(titleReview) <- c("Title", "Score")
titleReview <- as.data.table(titleReview)
bookReviewCount <- as.data.table(table(ratings$Title))
colnames(bookReviewCount) <- c("Title", "Count")

booksAverageScores <- titleReview %>%
                      group_by(Title) %>%
                      summarize(MeanScore = mean(as.numeric(Score)))

titleCountScore <- merge(bookReviewCount, booksAverageScores, by="Title")
plot(titleCountScore$MeanScore, log2(titleCountScore$Count))
cor(titleCountScore$Count, titleCountScore$MeanScore)

reviewCountScore <- cbind(Score=titleCountScore$MeanScore, Count=log2(titleCountScore$Count))

library(cluster)
clusters <- kmeans(reviewCountScore, centers=4)

clusplot(reviewCountScore, clusters$cluster, color=TRUE, shade=TRUE, 
         labels=4, lines=0, main="K-means cluster plot")
