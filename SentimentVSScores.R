library(syuzhet)
library(data.table)
library(tidyverse)
library(dplyr)
setwd("C:/Users/julio/Dropbox/PC/Desktop/Books/")

ratings <- data.table::fread("reviews_data_modified.csv")

sentiment <- fread("SentimentData.csv")


selectedScores <- ratings[sentiment$Index,]$`Review/Score`
selectedScores <- as.data.table(selectedScores)

posSentimentScore <- cbind(Score= selectedScores$selectedScores, Positive= sentiment$positive)
posSentimentScore <- as.data.table(posSentimentScore)

negSentimentScore <- cbind(Score= selectedScores$selectedScores, Negative= sentiment$negative)
negSentimentScore <- as.data.table(negSentimentScore)

posSentimentScore <- posSentimentScore %>%
                     group_by(Score) %>%
                     summarize(Mean = mean(as.numeric(Positive)))
negSentimentScore <- negSentimentScore %>%
                     group_by(Score) %>%
                     summarize(Mean = mean(as.numeric(Negative)))
posSentimentScore <- posSentimentScore %>% mutate(Type="Positive")
negSentimentScore <- negSentimentScore %>% mutate(Type="Negative")

meanSentimentScore <- rbindlist(list(posSentimentScore, negSentimentScore))
meanSentimentScore[Type == "Negative"]$Mean <- -meanSentimentScore[Type == "Negative"]$Mean


plt <- ggplot(meanSentimentScore, aes(x=Score, y=Mean, fill=Type)) + 
  geom_bar(position="stack", stat="Identity")+
  theme_minimal() +
  scale_x_continuous(limits= c(0.5, 5.5))+
  scale_y_continuous(limits = c(-7, 10), expand = c(0, 0, 0, 0), breaks = c(-15, -10, -5, 0, 5, 10, 15)) +
  labs(
    title = "Sentiment By Score",
    x = "Score",
    y = "Sentiment Magnitude"
  ) +
  theme(
    plot.title = element_text(color = "black", size = 16, face = "bold", ),
    axis.text.y = element_text(angle=45),
    axis.title = element_text(face="bold"),
    axis.line.y = element_line(arrow = arrow(angle = 30,
                                             length = unit(0.05, "inches"),
                                             ends = "both", 
                                             type = "closed"), linewidth = 0.5),
  )+
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0)

ggsave(filename="SentimentByScore.png", plt, unit="px", width=1080, height=1080, dpi=162, bg= "white")
