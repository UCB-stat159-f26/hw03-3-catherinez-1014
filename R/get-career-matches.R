player_slug <- function(player) {
  if (!is.character(player) || length(player) != 1L ||
      is.na(player) || !nzchar(trimws(player))) {
    stop("Provide one non-empty player name.", call. = FALSE)
  }
  name <- trimws(iconv(player, to = "ASCII//TRANSLIT"))
  if (is.na(name) || !grepl("[A-Za-z]", name)) {
    stop("Provide a player name containing letters.", call. = FALSE)
  }
  name <- gsub("([a-z])([A-Z])", "\\1 \\2", name)
  words <- strsplit(tolower(name), "[^a-z]+")[[1L]]
  words <- words[nzchar(words)]
  paste0(toupper(substr(words, 1L, 1L)), substring(words, 2L), collapse = "")
}

read_tennis_abstract <- function(address) {
  tryCatch({
    connection <- url(address, method = "libcurl")
    on.exit(close(connection), add = TRUE)
    suppressWarnings(readLines(connection, warn = FALSE))
  }, error = function(error) NULL)
}

parse_player_dob <- function(profile) {
  pattern <- "\\bvar\\s+dob\\s*=\\s*['\"]?([0-9]{8})['\"]?\\s*;"
  text <- paste(profile, collapse = "\n")
  matched <- regmatches(text, regexec(pattern, text, perl = TRUE))[[1L]]
  if (length(matched) < 2L) return(as.Date(NA_character_))
  as.Date(matched[2L], format = "%Y%m%d")
}

fetch_player_dob <- function(base_url, slug) {
  for (page in c("player.cgi", "wplayer.cgi")) {
    address <- paste0(base_url, "/cgi-bin/", page, "?p=", slug)
    dob <- parse_player_dob(read_tennis_abstract(address))
    if (!is.na(dob)) return(dob)
  }
  as.Date(NA_character_)
}

get_career_matches <- function(player) {
  slug <- player_slug(player)
  base_url <- "https://www.tennisabstract.com"
  career_url <- paste0(base_url, "/jsmatches/", slug, "Career.js")
  career <- read_tennis_abstract(career_url)
  if (!any(grepl("\\bmorematchmx\\s*=", career, perl = TRUE))) {
    stop(sprintf(
      "Could not retrieve Tennis Abstract career matches for '%s'. Check the player name and your connection.",
      player
    ), call. = FALSE)
  }
  dob <- fetch_player_dob(base_url, slug)
  if (is.na(dob)) {
    stop(sprintf("Could not find a birth date for '%s' on Tennis Abstract.", player),
         call. = FALSE)
  }
  clean_career_matches(career, dob)
}
