.comb <- function(n, x) {
  factorial(n) / factorial(n - x) / factorial(x)
}

.bivariate_poisson_negative_loglikelihood <- function(parameters, results) {
  # Split up parameters
  n <- length(parameters)
  strengths <- c(parameters[1:(n - 3)], 0)
  beta0 <- parameters[n - 2]
  h <- parameters[n - 1]
  betaC <- exp(parameters[n])
  # Calculate lambdas for all matches and both teams
  loglambdasHome <- beta0 + h*(!results$neutral) + strengths[results$homeId] - strengths[results$awayId]
  loglambdasAway <- beta0 + strengths[results$awayId] - strengths[results$homeId]
  lambdasHome <- exp(loglambdasHome)
  lambdasAway <- exp(loglambdasAway)

  # Calculate negative log likelihood
  logchances <- -(lambdasHome + lambdasAway + betaC) + loglambdasHome * results$home_score +
    loglambdasAway * results$away_score
  lambdaratio <- betaC / (lambdasHome * lambdasAway)
  results$mingoal <- pmin(results$home_score, results$away_score)
  xymin <- max(results$mingoal)
  som <- 1
  for (k in 1:xymin) {
    term <- (results$mingoal >= k) * .comb(n = pmax(results$home_score, k), x = k) *
      .comb(n = pmax(results$home_score, k), x = k) * factorial(k)
    term[is.nan(term)] <- 0
    term <- term * lambdaratio^k
    som <- som + term
  }
  out <- -sum(logchances + log(som))
  out
}


#' Estimate the team strengths
#'
#' This function estimates the strengths of the teams, given the results, based on a Bivariate Poisson model.
#' @param results The results of the played matches.
#' @return A list with two parts: 1) a dataframe with the estimated ratings of the teams 2) A list with additional parameters
#' @examples
#' teams <- paste0("Team ", LETTERS[1:10])
#' results <- subset(merge(teams, teams), x != y)
#' colnames(results) <- c("home_team", "away_team")
#' rownames(results) <- NULL
#' results$home_score <- rpois(nrow(results), lambda = 1)
#' results$away_score <- rpois(nrow(results), lambda = 1)
#' team_ratings(results)
#' @export

team_ratings <- function(results) {
  results$neutral<-ifelse(is.null(results$neutral), FALSE, results$neutral)
  teams <- unique(sort(c(results$home_team, results$away_team)))
  nb.teams <- length(teams)
  results$homeId <- match(results$home_team, teams)
  results$awayId <- match(results$away_team, teams)
  nb.parameters <- nb.teams + 2
  parameters <- rep(0, nb.parameters)
  MLE <- optim(parameters, .bivariate_poisson_negative_loglikelihood, results = results, method = "BFGS")
  strengths <- c(MLE$par[1:(nb.teams - 1)], 0)
  strengths <- scale(strengths, scale = F)
  ratings <- data.frame(teams, strengths)
  ratings <- ratings[order(ratings$strengths, decreasing = T), ]
  rownames(ratings) <- NULL
  return(list(ratings = ratings, parameters = list(intercept = MLE$par[nb.teams], home_effect = MLE$par[nb.teams + 1], covariance = exp(MLE$par[nb.teams + 2]))))
}
