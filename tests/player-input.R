player_slug <- tenniscareer:::player_slug
parse_player_dob <- tenniscareer:::parse_player_dob

expect_error <- function(expression, message) {
  error <- tryCatch(force(expression), error = identity)
  stopifnot(inherits(error, "error"),
            grepl(message, conditionMessage(error), fixed = TRUE))
}

# Required name formats should produce the same URL slug.
for (name in c("serena williams", "Serena Williams", "SerenaWilliams",
               "  Serena   Williams  ")) {
  stopifnot(identical(player_slug(name), "SerenaWilliams"))
}
stopifnot(identical(player_slug("Rafael Nadal"), "RafaelNadal"))

# Invalid inputs must fail before making a network request.
for (invalid in list("", "   ", NA_character_, character(), 123,
                     c("Serena Williams", "Rafael Nadal"))) {
  expect_error(tenniscareer::get_career_matches(invalid),
               "Provide one non-empty player name.")
}
expect_error(tenniscareer::get_career_matches("123"),
             "Provide a player name containing letters.")

# Birth dates are parsed from local mock profile content.
expected_dob <- as.Date("1981-09-26")
profiles <- list(
  "var dob = 19810926;",
  "var dob='19810926';",
  'var dob = "19810926";',
  c("<script>", "var dob = 19810926;", "</script>")
)
for (profile in profiles) {
  stopifnot(identical(parse_player_dob(profile), expected_dob))
}
stopifnot(is.na(parse_player_dob(NULL)),
          is.na(parse_player_dob("var other = 19810926;")),
          is.na(parse_player_dob("var dob = 19811340;")))

cat("Offline player-input tests passed.\n")
