setwd("C:/Users/julio/Dropbox/PC/Desktop/Books/")

ratings <- data.table::fread("reviews_data_modified.csv")
library(data.table)

downvotes <- ratings$HelpfulnessReviews - ratings$Upvotes

helpfulnessScore <- cbind(Upvotes=ratings$Upvotes, Downvotes=downvotes, Score=ratings$`Review/Score`)
helpfulnessScore <- as.data.table(helpfulnessScore)
library(tidyverse)
library(dplyr)
meanUpScore <- helpfulnessScore %>%
               group_by(Score) %>%
               summarize(Mean = mean(as.numeric(Upvotes)))
plot(meanUpScore)
meanDownScore <- helpfulnessScore %>%
                 group_by(Score) %>%
                 summarize(Mean = mean(as.numeric(Downvotes)))
plot(meanDownScore)

meanUpScore <- meanUpScore %>% mutate(Type="Positive")
meanDownScore <- meanDownScore %>% mutate(Type="Negative")

meanHelpScore <-rbindlist(list(meanUpScore, meanDownScore))
meanHelpScore[Type=="Negative"]$Mean <- -meanHelpScore[Type=="Negative"]$Mean 


plt<- ggplot(meanHelpScore, aes(x=Score, y=Mean, fill=Type), fill="white") + 
  geom_bar(position="stack", stat="Identity")+
  theme_minimal() +
  scale_x_continuous(limits= c(0.5, 5.5))+
  scale_y_continuous(limits = c(-15, 15), expand = c(0, 0, 0, 0), breaks = c(-15, -10, -5, 0, 5, 10, 15)) +
  labs(
    title = "Mean Helpfulness given to posts by Score",
    x = "Score",
    y = "Mean Helpfulness"
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

ggsave(filename="HelpfulnessByScore.png", plt, unit="px", width=1080, height=1080, dpi=162, bg= "white")
