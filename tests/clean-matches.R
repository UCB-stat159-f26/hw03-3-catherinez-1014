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
