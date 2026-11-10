\name{get_career_matches}
\alias{get_career_matches}
\title{Retrieve Tennis Career Matches}
\usage{
get_career_matches(player)
}
\arguments{
  \item{player}{A player name, such as \code{"serena williams"},
  \code{"Serena Williams"}, or \code{"SerenaWilliams"}.}
}
\description{
Retrieves and cleans a player's career match data from Tennis Abstract.
An internet connection is required.
}
\value{
A data frame sorted by match date, with columns \code{date},
\code{tournament}, \code{surface}, \code{result}, \code{opponent},
\code{player_age}, \code{opponent_age}, and \code{age_difference}.
Ages are measured in years, and the age difference is the player's age
minus the opponent's age.
}
\examples{
\dontrun{
serena <- get_career_matches("serena williams")
head(serena)
}
}
