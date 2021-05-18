.simulate_league_table<-function(simulation, remaining_matches, results){
  remaining_matches[c("home_score","away_score")]<-simulation
  results<-results[colnames(remaining_matches)]
  results<-rbind(results, remaining_matches)
  table1<-league_table(results)
  return(table1$team)
}


#' Simulate the remainder of a double round robin league and create a probabilistic final standing.
#'
#' This function creates a probabilistic final standing, given the played matches
#' @param results The results of the played matches.
#' @param mtr logical. If true, the ranks of teams with equal number of points is determined by their mutual results.
#' @param criteria The order of criteria on which the table is made when teams have equal number of points. Possible criteria are the goal difference ("GD"), the number of goals scored ("GS") and the number of matches won ("W")
#' @param strengths logical. If true, the function also returns the estimated team strengths
#' @return A dataframe with the probabilistic final standing of the league.
#' @examples
#' teams<-paste0("Team ",LETTERS[1:10])
#' results<-subset(merge(teams, teams), x!=y)
#' colnames(results)<-c("home_team","away_team")
#' rownames(results)<-NULL
#' results$home_score<-rpois(nrow(results),lambda = 1)
#' results$away_score<-rpois(nrow(results),lambda = 1)
#' simulate_league(results)
#' @export

simulate_league<-function(results, S=10000, mtr=FALSE, criteria=c("GD","GS","W"), strengths=FALSE){
  teams<-sort(unique(c(results$home_team, results$away_team)))
  nb.teams<-length(teams)
  all_matches<-subset(merge(teams, teams), x!=y)
  colnames(all_matches)<-c("home_team","away_team")
  rownames(all_matches)<-NULL
  remaining_matches<-all_matches[!paste0(all_matches$home_team, all_matches$away_team)%in%
                                   paste0(results$home_team, results$away_team),]
  nmatch<-nrow(remaining_matches)
  MLE<-team_ratings(results)
  ratings<-MLE$ratings
  sim_data<-merge(remaining_matches,ratings,by.x="home_team", by.y="teams")
  sim_data<-merge(sim_data,ratings, by.x="away_team",by.y="teams")
  beta0<-MLE$parameters$intercept
  h<-MLE$parameters$home_effect
  betaC<-MLE$parameters$covariance
  sim_data$lambda1<-exp(beta0+h+sim_data$strengths.x-sim_data$strengths.y)
  sim_data$lambda2<-exp(beta0+sim_data$strengths.y-sim_data$strengths.x)
  cov_goals<-rpois(S*nmatch,lambda=betaC)
  simulated_home_goals<-rpois(S*nmatch,lambda=sim_data$lambda1)+cov_goals
  simulated_away_goals<-rpois(S*nmatch,lambda=sim_data$lambda2)+cov_goals
  simulations<-array(data=c(simulated_home_goals, simulated_away_goals), dim=c(nmatch,S,2))
  all_tables<-apply(simulations,2,.simulate_league_table, remaining_matches, results)
  PFS<-data.frame(matrix(0, nrow=nb.teams, ncol=nb.teams))
  team_probs<-function(y){sapply(teams, function(x){mean(all_tables[y,]==x)})}
  PFS<-sapply(1:nb.teams, team_probs)
  exp_rank<-sapply(teams, function(team){PFS[team,]%*%1:nb.teams})
  PFS<-data.frame(cbind(PFS, exp_rank))
  PFS<-PFS[order(exp_rank),]
  if(strengths){
    return(list(PFS=PFS,ratings=ratings))
  }else{
    return(PFS)
  }

}
