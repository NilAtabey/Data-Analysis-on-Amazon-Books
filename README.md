# Data-Analysis-on-Amazon-Books

This is the public repository for the Data Management and Analysis Unit 2 Project.

## Authors

- [B. Nil Atabey](https://github.com/NilAtabey)
- [Julio Zenelaj](https://github.com/juve-938383)

## Project Overview

The goal of this project is to perform data analysis on a dataset of Amazon book reviews. The analysis includes various tasks such as data preparation, sentiment analysis, network analysis, and visualization. The primary programming language used for this project is R.

## Repository Structure

- **AuthorGraph.R:** Script for generating graphs related to authors.
- **BipartiteAnalysisScript.R:** Script for bipartite analysis.
- **Data preparation script.R:** Script for preparing the data for analysis.
- **N-DistributionOfBooksByGenre.R:** Analysis of the distribution of books by genre.
- **N-IRRELEVANT-ComparisonOf5vs1StarByCategory.R:** Comparison analysis of 5-star vs. 1-star reviews by category.
- **N-MarketVsReviewPercentage.R:** Analysis of market share vs. review percentage.
- **N-NumberOfBooksPerAuthor.R:** Analysis of the number of books per author.
- **N-PercentageDistributionOfAllRatings.R:** Percentage distribution of all ratings.
- **N-PublishersWith1000Books.R:** Analysis of publishers with 1000 or more books.
- **N-ReviewsByGenres.R:** Analysis of reviews by genres.
- **N-Top10MostActiveUsers.R:** Analysis of the top 10 most active users.
- **N-Top10MostReviewedBooks.R:** Analysis of the top 10 most reviewed books.
- **N-UserNetworkByReviews-Color.R:** Network analysis of users by reviews (color-coded).
- **N-UserNetworkByReviews-Thickness.R:** Network analysis of users by reviews (thickness-coded).
- **PlottingManual.R:** Manual for plotting data.
- **ReviewCount vs MeanScore.R:** Analysis of review count versus mean score.
- **SentimentAnalysis.R:** Sentiment analysis of reviews.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/NilAtabey/Data-Analysis-on-Amazon-Books.git
2. Or you can download each analysis individually. Make sure to change the working directories
   ```R
   # Load the datasets for books and reviews
    reviews <- fread("C:/Users/YourUser/FolderLocation/reviews_data_modified.csv")
    books <- fread("C:/Users/YourUser/FolderLocation/books_data_modified.csv")

## Prerequisites

Make sure you have the following installed:
- R (version 4.0 or higher)
- R Studio or equivalent IDE
- R packages: dplyr, ggplot2, data.table, igraph, tidyverse, and any other packages specified in the scripts.

## Contributions

Contributions to this project are welcome. Please fork the repository, create a new branch, and submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contact

For any questions or comments, please open an issue in this repository or contact us directly.
