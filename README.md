
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PFSC

<!-- badges: start -->
<!-- badges: end -->

The PFSC package provides functions to simulate the remainder of
prematurely stopped soccer leagues. It calculates for each team the
probabilities to reach each position in the final league table.

## Installation

You can install this package from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("vaneetvelde/PFSC")
```

## Simple example

``` r
library(PFSC)
#Create 10 teams and draw some match results
teams <- paste0("Team ", LETTERS[1:10])
results <- subset(merge(teams, teams), x != y)
colnames(results) <- c("home_team", "away_team")
rownames(results) <- NULL
results$home_score <- rpois(nrow(results), lambda = 1)
results$away_score <- rpois(nrow(results), lambda = 1)
results <- results[sample(nrow(results), 50), ]

# The intermediate league table
table1<-league_table(results)
table1
#>      team  M W D L GS GC GD  P
#> 1  Team A 11 8 1 2 15  9  6 25
#> 2  Team G 12 5 3 4 17 13  4 18
#> 3  Team C 10 4 3 3 11 12 -1 15
#> 4  Team B 10 4 2 4 10 11 -1 14
#> 5  Team E 11 3 4 4  9 12 -3 13
#> 6  Team H 10 4 0 6  8  6  2 12
#> 7  Team D 10 3 3 4  7 10 -3 12
#> 8  Team J 13 3 3 7 12 17 -5 12
#> 9  Team I  7 2 3 2  6  5  1  9
#> 10 Team F  6 2 2 2  8  8  0  8

# The estimated team strengths
ratings<-team_ratings(results)$ratings
ratings
#>     teams   strengths
#> 1  Team A  0.25678026
#> 2  Team H  0.14367433
#> 3  Team G  0.14316187
#> 4  Team I  0.08005687
#> 5  Team F -0.05247532
#> 6  Team C -0.05875596
#> 7  Team B -0.07059924
#> 8  Team D -0.14098002
#> 9  Team E -0.14492675
#> 10 Team J -0.15593604


# The probabistic final standing
PFS<-simulate_league(results, S = 1000)
PFS
#>        Pos.1 Pos.2 Pos.3 Pos.4 Pos.5 Pos.6 Pos.7 Pos.8 Pos.9 Pos.10 exp_rank
#> Team A 0.955 0.036 0.009 0.000 0.000 0.000 0.000 0.000 0.000  0.000    1.054
#> Team G 0.011 0.303 0.225 0.169 0.138 0.082 0.044 0.021 0.007  0.000    3.689
#> Team H 0.004 0.148 0.168 0.174 0.153 0.128 0.084 0.068 0.047  0.026    4.848
#> Team I 0.016 0.165 0.171 0.144 0.123 0.099 0.107 0.082 0.062  0.031    4.917
#> Team C 0.008 0.151 0.148 0.137 0.155 0.154 0.107 0.083 0.040  0.017    4.944
#> Team B 0.004 0.082 0.111 0.160 0.133 0.156 0.140 0.104 0.071  0.039    5.583
#> Team F 0.002 0.087 0.089 0.091 0.115 0.117 0.144 0.122 0.131  0.102    6.267
#> Team D 0.000 0.018 0.043 0.074 0.089 0.118 0.137 0.167 0.210  0.144    7.239
#> Team E 0.000 0.007 0.033 0.048 0.082 0.103 0.158 0.202 0.176  0.191    7.549
#> Team J 0.000 0.003 0.003 0.003 0.012 0.043 0.079 0.151 0.256  0.450    8.910
```

## Real example

We give the example of the stopped season of the French first ligue in
2019-2020.

``` r
library(PFSC)
results<-read.csv("https://www.football-data.co.uk/mmz4281/1920/F1.csv")
results<-results[,4:7]
colnames(results)<-c("home_team","away_team","home_score","away_score")

# The intermediate league table
table1<-league_table(results)
table1
#>           team  M  W  D  L GS GC  GD  P
#> 1     Paris SG 27 22  2  3 75 24  51 68
#> 2    Marseille 28 16  8  4 41 29  12 56
#> 3       Rennes 28 15  5  8 38 24  14 50
#> 4        Lille 28 15  4  9 35 27   8 49
#> 5        Reims 28 10 11  7 26 21   5 41
#> 6         Nice 28 11  8  9 41 38   3 41
#> 7         Lyon 28 11  7 10 42 27  15 40
#> 8  Montpellier 28 11  7 10 35 34   1 40
#> 9       Monaco 28 11  7 10 44 44   0 40
#> 10      Angers 28 11  6 11 28 33  -5 39
#> 11  Strasbourg 27 11  5 11 32 32   0 38
#> 12    Bordeaux 28  9 10  9 40 34   6 37
#> 13      Nantes 28 11  4 13 28 31  -3 37
#> 14       Brest 28  8 10 10 34 37  -3 34
#> 15        Metz 28  8 10 10 27 35  -8 34
#> 16       Dijon 28  7  9 12 27 37 -10 30
#> 17  St Etienne 28  8  6 14 29 45 -16 30
#> 18       Nimes 28  7  6 15 29 44 -15 27
#> 19      Amiens 28  4 11 13 31 50 -19 23
#> 20    Toulouse 28  3  4 21 22 58 -36 13

# The estimated team strengths
ratings<-team_ratings(results)$ratings
ratings
#>          teams    strengths
#> 1     Paris SG  0.854030618
#> 2         Lyon  0.281248927
#> 3       Rennes  0.235266949
#> 4    Marseille  0.185831707
#> 5        Lille  0.154852728
#> 6     Bordeaux  0.152263818
#> 7        Reims  0.076966355
#> 8         Nice  0.027839532
#> 9  Montpellier  0.023819729
#> 10      Monaco  0.010889382
#> 11  Strasbourg -0.006250803
#> 12      Nantes -0.020417435
#> 13       Brest -0.089217055
#> 14      Angers -0.096617968
#> 15        Metz -0.161858240
#> 16       Dijon -0.167749627
#> 17       Nimes -0.270650224
#> 18  St Etienne -0.285755708
#> 19      Amiens -0.316029198
#> 20    Toulouse -0.588463488

# The probabistic final standing
PFS_France<-simulate_league(results, S=10000)
PFS_France
#>             Pos.1  Pos.2  Pos.3  Pos.4  Pos.5  Pos.6  Pos.7  Pos.8  Pos.9
#> Paris SG        1 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Marseille       0 0.7821 0.1702 0.0451 0.0024 0.0002 0.0000 0.0000 0.0000
#> Rennes          0 0.1110 0.4168 0.3709 0.0740 0.0195 0.0048 0.0018 0.0009
#> Lille           0 0.1049 0.3778 0.4029 0.0796 0.0214 0.0087 0.0036 0.0008
#> Lyon            0 0.0018 0.0210 0.0979 0.3402 0.1877 0.1239 0.0789 0.0538
#> Reims           0 0.0000 0.0045 0.0208 0.1215 0.1576 0.1538 0.1351 0.1167
#> Montpellier     0 0.0001 0.0044 0.0208 0.1146 0.1419 0.1322 0.1287 0.1141
#> Bordeaux        0 0.0001 0.0022 0.0141 0.0712 0.1209 0.1268 0.1278 0.1208
#> Nice            0 0.0000 0.0015 0.0096 0.0541 0.1017 0.1252 0.1244 0.1290
#> Strasbourg      0 0.0000 0.0008 0.0064 0.0533 0.0869 0.1093 0.1151 0.1220
#> Nantes          0 0.0000 0.0005 0.0053 0.0418 0.0695 0.0830 0.1008 0.1152
#> Monaco          0 0.0000 0.0002 0.0050 0.0325 0.0590 0.0813 0.1026 0.1152
#> Angers          0 0.0000 0.0001 0.0012 0.0142 0.0312 0.0463 0.0679 0.0869
#> Metz            0 0.0000 0.0000 0.0000 0.0002 0.0013 0.0023 0.0061 0.0113
#> Brest           0 0.0000 0.0000 0.0000 0.0004 0.0012 0.0017 0.0062 0.0108
#> Dijon           0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0007 0.0006 0.0017
#> St Etienne      0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0004 0.0007
#> Nimes           0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0001
#> Amiens          0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Toulouse        0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#>             Pos.10 Pos.11 Pos.12 Pos.13 Pos.14 Pos.15 Pos.16 Pos.17 Pos.18
#> Paris SG    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Marseille   0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Rennes      0.0002 0.0001 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Lille       0.0001 0.0002 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Lyon        0.0408 0.0251 0.0163 0.0083 0.0035 0.0007 0.0001 0.0000 0.0000
#> Reims       0.1034 0.0821 0.0576 0.0307 0.0123 0.0034 0.0003 0.0002 0.0000
#> Montpellier 0.1027 0.0921 0.0707 0.0481 0.0208 0.0066 0.0019 0.0003 0.0000
#> Bordeaux    0.1083 0.1045 0.0889 0.0677 0.0321 0.0108 0.0031 0.0006 0.0001
#> Nice        0.1210 0.1183 0.0971 0.0730 0.0317 0.0095 0.0031 0.0007 0.0001
#> Strasbourg  0.1204 0.1144 0.1084 0.0922 0.0463 0.0172 0.0054 0.0017 0.0002
#> Nantes      0.1238 0.1219 0.1278 0.1145 0.0613 0.0237 0.0086 0.0021 0.0002
#> Monaco      0.1255 0.1314 0.1420 0.1124 0.0636 0.0220 0.0064 0.0009 0.0000
#> Angers      0.1106 0.1298 0.1546 0.1687 0.1127 0.0527 0.0185 0.0041 0.0005
#> Metz        0.0208 0.0369 0.0575 0.1142 0.2323 0.2252 0.1634 0.0899 0.0353
#> Brest       0.0181 0.0314 0.0521 0.0975 0.2004 0.2537 0.1797 0.1026 0.0403
#> Dijon       0.0024 0.0065 0.0142 0.0393 0.0920 0.1716 0.2387 0.2408 0.1531
#> St Etienne  0.0019 0.0048 0.0105 0.0269 0.0661 0.1369 0.2248 0.2673 0.1949
#> Nimes       0.0000 0.0005 0.0023 0.0064 0.0234 0.0591 0.1196 0.2222 0.3843
#> Amiens      0.0000 0.0000 0.0000 0.0001 0.0015 0.0069 0.0264 0.0666 0.1905
#> Toulouse    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0005
#>             Pos.19 Pos.20 exp_rank
#> Paris SG    0.0000 0.0000   1.0000
#> Marseille   0.0000 0.0000   2.2684
#> Rennes      0.0000 0.0000   3.5022
#> Lille       0.0000 0.0000   3.5813
#> Lyon        0.0000 0.0000   6.3168
#> Reims       0.0000 0.0000   8.1163
#> Montpellier 0.0000 0.0000   8.4424
#> Bordeaux    0.0000 0.0000   8.9942
#> Nice        0.0000 0.0000   9.2313
#> Strasbourg  0.0000 0.0000   9.5867
#> Nantes      0.0000 0.0000  10.0645
#> Monaco      0.0000 0.0000  10.1675
#> Angers      0.0000 0.0000  11.2378
#> Metz        0.0033 0.0000  14.4349
#> Brest       0.0039 0.0000  14.6170
#> Dijon       0.0384 0.0000  16.0620
#> St Etienne  0.0647 0.0001  16.4163
#> Nimes       0.1806 0.0015  17.4011
#> Amiens      0.6957 0.0123  18.5737
#> Toulouse    0.0134 0.9861  19.9856
```
