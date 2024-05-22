#Strip unnecessary book columns
books <- data.table::fread("C:/Users/julio/Dropbox/PC/Desktop/Books/books_data.csv")
new_books_table <- cbind(books$Title, books$description, books$authors, books$publisher, books$publishedDate, books$categories, books$ratingsCount)
colnames(new_books_table) = c("Title", "Description", "Authors", "Publisher", "PublishedDate", "Categories", "RatingsCount")
data.table::fwrite(new_books_table, "C:/Users/julio/Dropbox/PC/Desktop/Books/books_data_modified.csv")


ratings <- data.table::fread("C:/Users/julio/Dropbox/PC/Desktop/Books/books_rating.csv")
time_column <- ratings$`review/time`

convert <- function(x){
  format(as.Date(as.POSIXct(x, origin = "1970-01-01")), format="%d %m %Y")
}

a <- head(ratings, 1000)

#Should take about 20 mins to finish
time_column <- lapply(time_column, convert)
final_time_column <- cbind(time_column)
colnames(final_time_column) <- c("ReviewTime")
data.table::fwrite(final_time_column, "C:/Users/julio/Dropbox/PC/Desktop/Books/reviews_time_converted.csv")
a$`review/time` <- lapply(a$`review/time`, function(x) as.Date(as.POSIXct(x, origin = "1970-01-01")))

time_column <- data.table::fread("C:/Users/julio/Dropbox/PC/Desktop/Books/reviews_time_converted.csv")
colnames(time_column) <- c("Day", "Month", "Year")
final_rating_table <- cbind(ratings$Id, ratings$Title, ratings$Price, ratings$User_id, ratings$profileName, ratings$`review/helpfulness`, ratings$`review/score`, ratings$`review/summary`, ratings$`review/text`, time_column$Day, time_column$Month, time_column$Year)
colnames(final_rating_table) <- c("ID", "Title", "Price", "UserID", "ProfileName", "Review/Helpfulness", "Review/Score", "Review/Summary", "Review/Text", "Time/Day", "Time/Month", "Time/Year")
data.table::fwrite(final_rating_table, "C:/Users/julio/Dropbox/PC/Desktop/Books/books_data_modified.csv")
