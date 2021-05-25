test_that("PFS structure", {
  teams <- paste0("Team ", LETTERS[1:10])
  results <- subset(merge(teams, teams), x != y)
  colnames(results) <- c("home_team", "away_team")
  rownames(results) <- NULL
  results$home_score <- rpois(nrow(results), lambda = 1)
  results$away_score <- rpois(nrow(results), lambda = 1)
  results <- results[sample(nrow(results), 50), ]
  PFS<-simulate_league(results, S = 1000)
  expect_s3_class(PFS, "data.frame")
  expect_equal(nrow(PFS), length(teams))
  expect_equal(ncol(PFS), length(teams)+1)
})
