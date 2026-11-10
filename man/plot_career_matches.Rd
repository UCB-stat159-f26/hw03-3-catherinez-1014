\name{plot_career_matches}
\alias{plot_career_matches}
\title{Plot Tennis Career Matches}
\usage{
plot_career_matches(matches)
}
\arguments{
  \item{matches}{A data frame returned by \code{get_career_matches()},
  with \code{player_age}, \code{age_difference}, and \code{result} columns.}
}
\description{
Plots player age against player age minus opponent age.
Each point represents a match and is colored by its outcome.
The horizontal line marks a zero age difference.
}
\value{A ggplot object.}
\examples{
matches <- data.frame(
  player_age = c(19, 20),
  age_difference = c(-3, 2),
  result = c("W", "L")
)
plot_career_matches(matches)
}
