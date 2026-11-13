clean_matches <- tenniscareer:::clean_career_matches

serena_js <- 'var morematchmx = [
  ["19951030", "Canadian Open", "Carpet", "W", "L", "", "", "WC", "Q1",
   "6-1 6-1", "3", "Anne Miller", "149", "7", "", "R", "19770119"]
]'

nadal_js <- 'var morematchmx = [
  ["20010910", "Spain F10", "Hard", "S", "L", "", "", "WC", "R32",
   "2-6 7-5 6-2", "3", "Guillermo Platel", "731", "", "", "R", "22.264202601"]
];'

serena <- clean_matches(serena_js, as.Date("1981-09-26"))
nadal <- clean_matches(nadal_js, as.Date("1986-06-03"))

expected_serena_opponent_age <- as.numeric(
  as.Date("1995-10-30") - as.Date("1977-01-19")
) / 365.25

stopifnot(
  nrow(serena) == 1L,
  nrow(nadal) == 1L,
  identical(serena$result, "L"),
  isTRUE(all.equal(serena$opponent_age, expected_serena_opponent_age)),
  isTRUE(all.equal(nadal$opponent_age, 22.264202601)),
  isTRUE(all.equal(nadal$age_difference, nadal$player_age - 22.264202601))
)

cat("Offline cleaning tests passed.\n")

# Build local records with the same first 17 fields as the raw data.
match_row <- function(date, result, opponent_age) {
  c(date, "Example Open", "Hard", "W", result, "", "", "WC", "R32",
    "6-1 6-1", "3", "Example Opponent", "149", "", "", "R", opponent_age)
}

career_js <- function(rows) {
  paste0("var morematchmx = ",
         jsonlite::toJSON(rows, auto_unbox = TRUE), ";")
}

expect_error <- function(expression, message) {
  error <- tryCatch(force(expression), error = identity)
  stopifnot(inherits(error, "error"),
            grepl(message, conditionMessage(error), fixed = TRUE))
}

# Unsorted female records must be sorted, with correct age calculations.
player_dob <- as.Date("1981-09-26")
records <- list(
  match_row("19970804", "W", "19790301"),
  match_row("19951030", "L", "19770119"),
  match_row("19970307", "L", "19700503")
)
matches <- clean_matches(career_js(records), player_dob)
dates <- as.Date(c("1995-10-30", "1997-03-07", "1997-08-04"))
opponent_dobs <- as.Date(c("1977-01-19", "1970-05-03", "1979-03-01"))
player_ages <- as.numeric(dates - player_dob) / 365.25
opponent_ages <- as.numeric(dates - opponent_dobs) / 365.25

stopifnot(
  identical(matches$date, dates),
  identical(matches$result, c("L", "L", "W")),
  isTRUE(all.equal(matches$player_age, player_ages)),
  isTRUE(all.equal(matches$opponent_age, opponent_ages)),
  isTRUE(all.equal(matches$age_difference, player_ages - opponent_ages)),
  identical(rownames(matches), as.character(1:3))
)

# Missing dates/ages and outcomes other than W/L must be removed.
player_dob <- as.Date("1986-06-03")
records <- list(
  match_row("20010910", "L", "22.264202601"),
  match_row("20010917", "W", ""),
  match_row("", "W", "24"),
  match_row("20010917", "", "24"),
  match_row("20010917", "W", "unknown")
)
filtered <- clean_matches(career_js(records), player_dob)
stopifnot(
  nrow(filtered) == 1L,
  identical(filtered$date, as.Date("2001-09-10"))
)

# Filtering every record should still return a data frame with its columns.
empty <- clean_matches(
  career_js(list(match_row("20010917", "W", ""))), player_dob
)
stopifnot(
  is.data.frame(empty),
  nrow(empty) == 0L,
  identical(names(empty), names(filtered))
)

# Missing arrays, short records, and empty arrays give meaningful errors.
expect_error(
  clean_matches("var unrelated = [];", player_dob),
  "Could not locate the morematchmx array."
)
expect_error(
  clean_matches('var morematchmx = [["20010910"]];', player_dob),
  "Expected match records with at least 17 fields."
)
expect_error(
  clean_matches("var morematchmx = [];", player_dob),
  "Expected match records with at least 17 fields."
)

cat("Extended offline cleaning tests passed.\n")
