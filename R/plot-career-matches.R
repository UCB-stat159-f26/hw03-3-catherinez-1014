plot_career_matches <- function(matches) {
  required <- c("player_age", "age_difference", "result")
  if (!is.data.frame(matches) || !all(required %in% names(matches))) {
    stop("Supply a data frame with player_age, age_difference, and result columns.",
         call. = FALSE)
  }
  ggplot2::ggplot(matches, ggplot2::aes(
    x = .data$player_age, y = .data$age_difference, color = .data$result
  )) +
    ggplot2::geom_hline(yintercept = 0, color = "grey55", linewidth = 0.5) +
    ggplot2::geom_point(size = 1.2, alpha = 0.8) +
    ggplot2::scale_color_manual(values = c(W = "#40C5E5", L = "#92378F"),
                               breaks = c("W", "L"), labels = c("Won", "Lost")) +
    ggplot2::scale_x_continuous(position = "top") +
    ggplot2::labs(title = "Career Match Results", x = "Player age (years)",
                  y = "Player age minus opponent age (years)", color = NULL,
                  caption = "Source: Tennis Abstract") +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "top", panel.grid.minor = ggplot2::element_blank())
}
