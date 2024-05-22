setwd("[ENTER YOUR DIRECTORY HERE]")

ratings <- data.table::fread("reviews_data_modified.csv")

library(ggplot2)
scores <- data.table::data.table(table(as.numeric(ratings$`Review/Score`)))
colnames(scores) <- c("Rating", "Count")


#HOW TO MAKE A GGPLOT
#Define the data
plt <- ggplot(scores, aes(x=scores$Rating, y=scores$Count)) +
  #Choose the plot type
  geom_bar(stat = "identity", color = "#000000", fill = "#0099F8")+
  #Customize
  #For details of each plot type and their attributes, look up online
  geom_text(aes(label=scores$Count), position=position_dodge(), vjust=-0.2, color="black", fontface="bold") +
  labs(
    title = "Rating Score distribution",
    x = "Score",
    y = "Count"
  ) +
  theme_bw() +
  scale_y_continuous(limits = c(0, 2*1e+6), expand = c(0, 0, 0, 0), breaks = c(0, 250000, 500000, 750000, 1000000, 1250000, 1500000, 1750000)) +
  theme(
    plot.title = element_text(color = "#0099F8", size = 16, face = "bold", ),
    axis.text.y = element_text(angle=45),
    axis.title = element_text(face="bold"),
    axis.line.y = element_line(arrow = arrow(angle = 30,
                                   length = unit(0.15, "inches"),
                                   ends = "last", 
                                   type = "closed"), linewidth = 0.8 ),
    axis.line.x = element_line(linewidth = 0.8)
  )
plt     

#Save plot
ggsave(filename="RatingScoreDistribution2.png", plt, unit="px", width=1080, height=1080, dpi=162)
