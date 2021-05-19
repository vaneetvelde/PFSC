.calculate_criteria <- function(team, m) {
  M <- sum(m$home_team == team | m$away_team == team)
  W <- sum((m$home_score > m$away_score & m$home_team == team) | (m$home_score < m$away_score & m$away_team == team))
  D <- sum(m$home_score == m$away_score & (m$home_team == team | m$away_team == team))
  L <- sum((m$home_score < m$away_score & m$home_team == team) | (m$home_score > m$away_score & m$away_team == team))
  GS <- sum(m$home_score[m$home_team == team]) + sum(m$away_score[m$away_team == team])
  GC <- sum(m$home_score[m$away_team == team]) + sum(m$away_score[m$home_team == team])
  GD <- GS - GC
  P <- 3 * W + D
  return(c(M, W, D, L, GS, GC, GD, P))
}

#' Create the official league table
#'
#' This function creates the official league table, given the match results.
#' @param results The results of the played matches.
#' @param mtr logical. If true, the ranks of teams with equal number of points is determined by their mutual results.
#' @param criteria The order of criteria on which the table is made when teams have equal number of points. Possible criteria are the goal difference ("GD"), the number of goals scored ("GS") and the number of matches won ("W")
#' @return A dataframe with the final standing of the league.
#' @export
#' @examples
#' teams <- paste0("Team ", LETTERS[1:10])
#' results <- subset(merge(teams, teams), x != y)
#' colnames(results) <- c("home_team", "away_team")
#' rownames(results) <- NULL
#' results$home_score <- rpois(nrow(results), lambda = 1)
#' results$away_score <- rpois(nrow(results), lambda = 1)
#' league_table(results)
league_table <- function(results, mtr = FALSE, criteria = c("GD", "GS", "W")) {
  m <- results
  teams <- sort(unique(c(m$home_team, m$away_team)))
  tab <- data.frame(
    team = teams, M = 0, W = 0, D = 0, L = 0, GS = 0,
    GC = 0, GD = 0, P = 0, stringsAsFactors = F
  )
  tab[c("M", "W", "D", "L", "GS", "GC", "GD", "P")] <- t(vapply(teams, FUN = .calculate_criteria, FUN.VALUE = numeric(8), m = results))
  for (i in length(criteria):1) {
    tab <- tab[order(tab[criteria[i]], decreasing = T), ]
  }
  tab <- tab[order(tab$P, decreasing = T), ]
  rownames(tab) <- NULL
  if (mtr) {
    tab$mtr <- 0
    pts <- unique(tab$P)
    pts <- pts[rowSums(outer(pts, tab$P, "==")) > 1]
    mt_teams1 <- tab$team[tab$P %in% pts]
    a <- lapply(pts, function(x) {
      mt_teams <- tab$team[tab$P == x]
      if (length(mt_teams) > 1) {
        mt_results <- m[m$home_team %in% mt_teams & m$away_team %in% mt_teams, ]
        if (nrow(mt_results) > 0) {
          mt_table <- league_table(mt_results, mtr = F, criteria = criteria)
          return(sapply(mt_teams, function(y) {
            which(mt_table$team == y)
          }))
        }
      }
    })
    tab$mtr[tab$team %in% mt_teams1] <- unlist(a)
    tab <- tab[order(tab$mtr), ]
    tab <- tab[order(tab$P, decreasing = T), ]
    rownames(tab) <- NULL
  }
  return(tab)
}
