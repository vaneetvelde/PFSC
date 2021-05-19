
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

## Example

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
#>             V1     V2     V3     V4     V5     V6     V7     V8     V9    V10
#> Paris SG     1 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Marseille    0 0.7888 0.1692 0.0390 0.0028 0.0002 0.0000 0.0000 0.0000 0.0000
#> Rennes       0 0.1068 0.4094 0.3739 0.0787 0.0213 0.0067 0.0018 0.0007 0.0005
#> Lille        0 0.1027 0.3814 0.4040 0.0776 0.0210 0.0079 0.0039 0.0009 0.0005
#> Lyon         0 0.0010 0.0273 0.0996 0.3393 0.1836 0.1217 0.0812 0.0549 0.0381
#> Reims        0 0.0001 0.0039 0.0191 0.1171 0.1524 0.1581 0.1396 0.1205 0.1009
#> Montpellier  0 0.0004 0.0030 0.0201 0.1086 0.1396 0.1331 0.1303 0.1117 0.1072
#> Bordeaux     0 0.0000 0.0021 0.0137 0.0742 0.1257 0.1272 0.1250 0.1227 0.1080
#> Nice         0 0.0001 0.0013 0.0100 0.0583 0.1031 0.1172 0.1258 0.1303 0.1255
#> Strasbourg   0 0.0000 0.0011 0.0089 0.0536 0.0882 0.1076 0.1188 0.1163 0.1255
#> Nantes       0 0.0000 0.0003 0.0042 0.0424 0.0700 0.0856 0.1008 0.1160 0.1125
#> Monaco       0 0.0001 0.0010 0.0052 0.0315 0.0610 0.0806 0.0962 0.1137 0.1258
#> Angers       0 0.0000 0.0000 0.0023 0.0153 0.0317 0.0490 0.0653 0.0862 0.1098
#> Metz         0 0.0000 0.0000 0.0000 0.0003 0.0010 0.0022 0.0055 0.0138 0.0217
#> Brest        0 0.0000 0.0000 0.0000 0.0003 0.0012 0.0028 0.0049 0.0096 0.0184
#> Dijon        0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0002 0.0005 0.0021 0.0032
#> St Etienne   0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0001 0.0004 0.0004 0.0024
#> Nimes        0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0002 0.0000
#> Amiens       0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Toulouse     0 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#>                V11    V12    V13    V14    V15    V16    V17    V18    V19
#> Paris SG    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Marseille   0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Rennes      0.0002 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Lille       0.0001 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000
#> Lyon        0.0247 0.0149 0.0109 0.0022 0.0005 0.0001 0.0000 0.0000 0.0000
#> Reims       0.0814 0.0554 0.0355 0.0121 0.0033 0.0005 0.0001 0.0000 0.0000
#> Montpellier 0.0899 0.0737 0.0510 0.0230 0.0065 0.0014 0.0004 0.0001 0.0000
#> Bordeaux    0.1033 0.0882 0.0662 0.0313 0.0091 0.0027 0.0006 0.0000 0.0000
#> Nice        0.1177 0.0913 0.0710 0.0331 0.0119 0.0029 0.0004 0.0001 0.0000
#> Strasbourg  0.1154 0.1039 0.0904 0.0455 0.0163 0.0067 0.0015 0.0003 0.0000
#> Nantes      0.1255 0.1292 0.1141 0.0617 0.0262 0.0086 0.0023 0.0006 0.0000
#> Monaco      0.1353 0.1388 0.1152 0.0643 0.0219 0.0077 0.0015 0.0002 0.0000
#> Angers      0.1272 0.1566 0.1656 0.1105 0.0550 0.0208 0.0043 0.0004 0.0000
#> Metz        0.0365 0.0628 0.1112 0.2328 0.2227 0.1668 0.0863 0.0332 0.0032
#> Brest       0.0293 0.0537 0.1012 0.2061 0.2413 0.1801 0.1065 0.0392 0.0053
#> Dijon       0.0083 0.0166 0.0381 0.0937 0.1714 0.2360 0.2354 0.1536 0.0409
#> St Etienne  0.0046 0.0126 0.0234 0.0592 0.1450 0.2219 0.2628 0.2025 0.0647
#> Nimes       0.0006 0.0023 0.0057 0.0227 0.0615 0.1187 0.2267 0.3860 0.1740
#> Amiens      0.0000 0.0000 0.0005 0.0018 0.0074 0.0251 0.0712 0.1834 0.6998
#> Toulouse    0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0004 0.0121
#>                V20 exp_rank
#> Paris SG    0.0000   1.0000
#> Marseille   0.0000   2.2564
#> Rennes      0.0000   3.5335
#> Lille       0.0000   3.5803
#> Lyon        0.0000   6.2891
#> Reims       0.0000   8.1555
#> Montpellier 0.0000   8.5090
#> Bordeaux    0.0000   8.9444
#> Nice        0.0000   9.2189
#> Strasbourg  0.0000   9.5524
#> Nantes      0.0000  10.0828
#> Monaco      0.0000  10.1951
#> Angers      0.0000  11.2314
#> Metz        0.0000  14.4028
#> Brest       0.0001  14.6255
#> Dijon       0.0000  16.0446
#> St Etienne  0.0000  16.4336
#> Nimes       0.0016  17.3895
#> Amiens      0.0108  18.5681
#> Toulouse    0.9875  19.9871
```
