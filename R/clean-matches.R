parse_match_rows <- function(js_text) {
  text <- paste(js_text, collapse = "\n")
  pattern <- "(?s)var\\s+morematchmx\\s*=\\s*(\\[.*?\\])\\s*(?:;|$)"
  matched <- regmatches(text, regexec(pattern, text, perl = TRUE))[[1]]
  if (length(matched) < 2L) {
    stop("Could not locate the morematchmx array.", call. = FALSE)
  }
  rows <- jsonlite::fromJSON(matched[2L], simplifyVector = FALSE)
  if (!length(rows) || any(lengths(rows) < 17L)) {
    stop("Expected match records with at least 17 fields.", call. = FALSE)
  }
  rows
}

match_field <- function(rows, column) {
  vapply(rows, function(row) {
    value <- row[[column]]
    if (is.null(value)) NA_character_ else as.character(value)
  }, character(1))
}

parse_opponent_age <- function(value, match_date) {
  is_dob <- grepl("^[0-9]{8}$", value)
  age <- suppressWarnings(as.numeric(value))
  dob <- as.Date(value[is_dob], format = "%Y%m%d")
  age[is_dob] <- as.numeric(match_date[is_dob] - dob) / 365.25
  age
}

clean_career_matches <- function(js_text, player_dob) {
  rows <- parse_match_rows(js_text)
  matches <- data.frame(
    date = as.Date(match_field(rows, 1L), format = "%Y%m%d"),
    tournament = match_field(rows, 2L),
    surface = match_field(rows, 3L),
    result = match_field(rows, 5L),
    opponent = match_field(rows, 12L),
    stringsAsFactors = FALSE
  )
  matches$player_age <- as.numeric(matches$date - player_dob) / 365.25
  matches$opponent_age <- parse_opponent_age(match_field(rows, 17L), matches$date)
  matches$age_difference <- matches$player_age - matches$opponent_age
  keep <- is.finite(matches$age_difference) & matches$result %in% c("W", "L")
  matches <- matches[keep, ]
  matches <- matches[order(matches$date), ]
  rownames(matches) <- NULL
  matches
}
