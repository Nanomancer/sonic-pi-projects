# Avalanche control

"" " Hat " ""
set :hatRate, 2 # 1 = every 1/16, 2 = every 1/8 etc...
set :numberOfOpenHats,  2#3  #2  #2  #3  #2 #3
set :hatPatternLength,  8#3  #2  #2  #3  #2 #3
set :hatOffset, 2
set :hatRotate, 2
set :hatPattern, spread(get[:numberOfOpenHats], get[:hatPatternLength], rotate: get[:hatRotate])
offbeat = false # This set of settings can be loaded from file in running buffer
set :muteHat, false
##| set :muteHat, true

"" " Kick " ""
set :numberOfKicks, 3
set :kickPatternLength, 10
set :kickRotate, 3
set :kickPattern, spread(get[:numberOfKicks], get[:kickPatternLength], rotate: get[:kickRotate])
set :muteKick, false
##| set :muteKick, true

"" " Snare " ""
set :numberOfSnares, 5
set :snarePatternLength, 16
set :snareRotate, 2
set :snareOffset, 3
set :snarePattern, spread(get[:numberOfSnares], get[:snarePatternLength], rotate: get[:snareRotate])
set :muteSnare, false
##| set :muteSnare = true

"" " Master settings " ""
randAmt = 0.05
randHigh = 1 + randAmt
randLow = 1 - randAmt
timingAmt = 0.000025
set :masterRate, 1 # speed, increase slows
set :masterPatternLength, 2 # bars to reset clocks at

set :dynamicPattern, [0.9, 0.45, 0.66, 0.5, 0.85, 0.4, 0.7, 0.4].ring
##| set :dynamicsArray, [1, 0.7, 0.85, 0.65, 0.95, 0.75, 0.9, 0.65].ring
