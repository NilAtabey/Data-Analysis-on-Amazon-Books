setwd("C:/Users/julio/Dropbox/PC/Desktop/Books")
reviews <- data.table::fread("reviews_data_modified.csv")
books <- data.table::fread("books_data_modified.csv")
library(igraph)
library(ggplot2)

edges <- data.frame("from"=reviews$ProfileName, "to"=reviews$Title, stringsAsFactors = F)
g <- graph.data.frame(edges, directed = F)
V(g)$type <- V(g)$name %in% edges[,1]

#ANALYZING THE BIPARTITE: some metrics
types <- V(g)$type                 ## getting each vertex `type` let's us sort easily
deg <- degree(g)
#bet <- betweenness(g)
#clos <- closeness(g)
eig <- eigen_centrality(g)$vector
cent_df <- data.frame(types, deg, bet, clos, eig)
cent_df[order(cent_df$type, decreasing = TRUE),] ## sort w/ `order` by `type`

#PLOT PROBABILITY DENSITY FUNCTION OF BET OR CLOS OR EIG
plot(density(bet), log = "xy",lty = 6)
plot(density(clos), log = "xy",lty = 6)
plot(density(eig), log = "xy",lty = 6)


head(deg)
plot(deg.histogram, xlim= c(0, 20)) + geom_histogram(binwidth=.5, colour="black", fill="white")
  
