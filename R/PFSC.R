create_table_temp<-function(matches){
  m<-matches
  teams<-sort(unique(m$home_team))
  tab<-data.frame(team=teams, points=0, win=0, draw=0, loss=0, goals=0,
                  goals_against=0, saldo=0, stringsAsFactors = F)
  for(i in 1:length(teams)){
    tab$win[tab$team==teams[i]]<-
      sum(m$home_team==teams[i]&m$home_score>m$away_score)+
      sum(m$away_team==teams[i] & m$home_score<m$away_score)
    tab$draw[tab$team==teams[i]]<-
      sum((m$home_team==teams[i]|m$away_team==teams[i])&
            m$home_score==m$away_score)
    tab$loss[tab$team==teams[i]]<-
      sum(m$home_team==teams[i]&m$home_score<m$away_score)+
      sum(m$away_team==teams[i] & m$home_score>m$away_score)
    tab$goals[tab$team==teams[i]]<-
      sum(m$home_score[m$home_team==teams[i]])+
      sum(m$away_score[m$away_team==teams[i]])
    tab$goals_against[tab$team==teams[i]]<-
      sum(m$home_score[m$away_team==teams[i]])+
      sum(m$away_score[m$home_team==teams[i]])
  }
  tab$matches<-tab$win+tab$draw+tab$loss
  tab$points<-3*tab$win+1*tab$draw
  tab$saldo<-tab$goals-tab$goals_against
  tab<-tab[order(tab$points, tab$saldo
                 ,tab$goals,runif(nrow(tab)),  decreasing = T),]
  return(tab)
}

correct_table<-function(tableX, matches){
  x<-unique(tableX$points)
  for(y in x){
    teams<-tableX$team[tableX$points==y]
    if(length(teams)>1){
      mt_games<-matches[matches$home_team %in% teams & matches$away_team%in% teams,]
      mt_table<-create_table_temp(mt_games)
      tableX[tableX$points==y,]<-mt_table
    }
  }
  return(tableX)
}

create_table_final<-function(simulation, remaining_matches, played_matches, mtr=F){
  remaining_matches[c("home_score","away_score")]<-simulation
  played_matches<-played_matches[colnames(remaining_matches)]
  matches<-rbind(played_matches, remaining_matches)
  tableEnd<-create_table_temp(matches)
  if(mtr==T){
    tableEnd<-correct_table(tableEnd, matches)
  }
  return(tableEnd$team)
}  