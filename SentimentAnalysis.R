library(syuzhet)
setwd("C:/Users/julio/Dropbox/PC/Desktop/Books/")

ratings <- data.table::fread("reviews_data_modified.csv")

#First 1000 reviews for testing
reviews <- ratings$`Review/Text`[1:100001]

sentiment = get_nrc_sentiment(reviews)
td = data.frame(t(sentiment))
td[,1:5]

td = data.frame(rowSums(td[-1]))
td
names(td)[1] <- "count"
td
tdw <- cbind("sentiment" = rownames(td), td)
tdw
rownames(tdw) <- NULL
tdw
td_em  = tdw[1:8, ] # emotions
td_pol = tdw[9:10, ] # polarity

require("ggplot2")
ggplot(td_em, aes(x = sentiment, y = count, fill = sentiment)) +
  geom_bar(stat = "identity") +
  labs(x = "emotion") +
  theme(axis.text.x=element_text(angle=45, hjust=1), legend.title = element_blank())

ggplot(td_pol, aes(x = sentiment, y = count, fill = sentiment)) +
  geom_bar(stat = "identity") +
  labs(x = "polarity") +
  theme(axis.text.x=element_text(angle=45, hjust=1), legend.title = element_blank())