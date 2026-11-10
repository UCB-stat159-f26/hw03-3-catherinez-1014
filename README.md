# tenniscareer

`tenniscareer` retrieves career match data from Tennis Abstract and plots
the player's age against the age difference between the player and each
opponent. Each point is colored by whether the player won or lost.

## Installation

```r
pak::pak("UCB-stat159-f26/hw03-3-catherinez-1014")
```

## Usage

```r
library(tenniscareer)

serena <- get_career_matches("serena williams")
head(serena)
plot_career_matches(serena)

nadal <- get_career_matches("Rafael Nadal")
plot_career_matches(nadal)
```

The age difference is the player's age minus the opponent's age, in years.
A positive value means the player was older. Retrieving match data
requires an internet connection. The automated cleaning tests use local
examples and do not contact Tennis Abstract.

## Reflection

In HW2, I hard-coded Serena Williams's birth date because the script
only needed to work for one player. Turning that script into a package
made me separate the steps that retrieve a player's birth date and match
records from the code that cleans those records. I also learned that the
same field can represent different things in two files. The women's
records store the opponent's birth date, while the men's records store
the opponent's age. Testing both formats with small local examples let
me check the age calculations without depending on the website.
