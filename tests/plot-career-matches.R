library(tenniscareer)

matches <- data.frame(
  player_age = c(19, 20),
  age_difference = c(-3, 2),
  result = c("W", "L")
)

chart <- plot_career_matches(matches)
points <- ggplot2::ggplot_build(chart)$data[[2L]]

stopifnot(
  isTRUE(all.equal(points$x, matches$player_age)),
  isTRUE(all.equal(points$y, matches$age_difference)),
  identical(points$colour, c("#40C5E5", "#92378F"))
)
