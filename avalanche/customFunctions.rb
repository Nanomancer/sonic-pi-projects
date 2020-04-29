define :syncTone do
  sample :elec_ping
  puts "SYNC"
  sleep 8
end

define :getNewSeed do
  SEED = Time.now.usec # get a different run every time
  puts "Epoch seed: #{SEED}"
  return SEED
end


define :mk_rand_scale do |scale, len = 8|
  # random scale that may contain the same note more than once
  rand_s = []
  len.times do
    rand_s << scale.choose
  end
  return rand_s.ring
end


define :calculateYAxis do |m, x, c|
  "" "
##| Linear, Where m is gradient and c is y-intercept.
##| Where C is minimum value of the parameter to reduce -
##| You need to calculate gradient!
##| m = ( y2 - y1 ) / ( x2 - x1 )
##| or,
##| m = ( y - c ) / x
##| x is a value from an array intended
##| to be used for amp / velocity.
##
" ""
  y = (m * x) + c
  return y
end

define :rand_1 do | aFloat |
  randLow = 1 - aFloat
  randHigh = 1 + aFloat
  return rrand(randLow, randHigh)
end


define :calculateReduction do |valuesMap, aDynamic|
  assert aDynamic <= 1 && aDynamic >= 0, "values for dynamic control should be between 0 an 1 inclusive, got: aDynamic = #{aDynamic}"
  modifier = calculateYAxis(valuesMap[:gradient], aDynamic, valuesMap[:y_int])
  return valuesMap[:maxValue] * rand_1(valuesMap[:randAmount]) * modifier
end

define :randomCompensation do |maxValue, randomAmount|
  return maxValue - (maxValue * (1 + randomAmount) - maxValue)
end

define :cutoffCompensation do |cutoffMap = cutoffMap|
  return randomCompensation(cutoffMap[:maxValue], cutoffMap[:randAmount])
end

define :playSplash do |anAmplitude|
  if one_in(3)
    sample :drum_splash_hard,
      rate: rrand(0.9, 1.1) * [1.25, 1, 1.5, 0.85].choose,
      amp: rrand(0.7, 1.0) * 0.4 * anAmplitude,
      cutoff: 131 * rand_1(0.2)
  else
    sample :drum_splash_soft,
      rate: rrand(0.9, 1.1) * [1.25, 1, 1.5, 0.85].choose,
      amp: rrand(0.7, 1.0) * anAmplitude,
      cutoff: 131 * rand_1(0.2)
  end
end

define :resetKick do
  
end


define :playKick do |aDynamic, kick_1_vol = 0.55, kick_2_vol = 0.35, sample_1 = :bd_fat, sample_2 = :bd_sone|
  cutoffMap = {
    maxValue: 131,
    gradient: 0.4,
    y_int: 0.6,
    randAmount: 0.01,
  }
  pitchMap = {
    maxValue: 1,
    gradient: 0.02,
    y_int: 0.98,
    randAmount: 0.0075,
  }
  cutoffMap[:maxValue] = randomCompensation(cutoffMap[:maxValue], cutoffMap[:randAmount])
  
  sample sample_1,
    cutoff: calculateReduction(cutoffMap, aDynamic),
    rate: calculateReduction(pitchMap, aDynamic),
    amp: kick_1_vol * aDynamic * rand_1(0.3)
  sample sample_2,
    cutoff: calculateReduction(cutoffMap, aDynamic),
    rate: calculateReduction(pitchMap, aDynamic),
    amp: kick_2_vol * aDynamic * rand_1(0.3)
end

define :playSnare do | anAmplitude, aDynamic, sample_1 = :drum_snare_hard |
  cutoffMap = {
    maxValue: 131 - ((131 * 1.08) - 131),
    gradient: 0.2,
    y_int: 0.8,
    randAmount: 0.08
  }
  pitchMap = {
    maxValue: 1,
    gradient: 0.08,
    y_int: 0.92,
    randAmount: 0.009
  }
  sample sample_1,
    cutoff: calculateReduction(cutoffMap, aDynamic),
    rate: calculateReduction(pitchMap, aDynamic),
    amp: anAmplitude * aDynamic * rrand(0.9, 1.1),
    attack: 0.0025 * rrand(0.9, 1.1)
end

##| sample :drum_cymbal_closed,
##|   cutoff: 130 * rrand(0.995, 1.00) * ( (0.2 * dynamicsArray.look(:hat)) + 0.8 ),
##|   rate: 1 * rrand(0.995, 1.005) * ( (0.04 * dynamicsArray.look(:hat)) + 0.96 ),
##|   attack: 0.0025 * rrand(0.9, 1.1),
##|   attack: 0.005 * rrand(randLow, randHigh),
##|   finish: rrand(0.75, 1),
##|   release: rrand(0.01, 0.05),
##|   amp: 0.45 * dynamicsArray.look(:hat) * rrand(0.8, 1.2)

##| define :playClosedHat do | aDynamic, sample_1 = :drum_cymbal_closed |
##|   cutoffMap = {
##|     maxValue: 130 - 0.08,
##|     gradient: 0.2,
##|     y_int: 0.8,
##|     randAmount: 0.08
##|   }
##|   pitchMap = {
##|     maxValue: 1,
##|     gradient: 0.08,
##|     y_int: 0.92,
##|     randAmount: 0.009
##|   }
##|   sample sample_1,
##|     cutoff: calculateReduction(cutoffMap, aDynamic),
##|     rate: calculateReduction(pitchMap, aDynamic),
##|     amp: 0.25 * aDynamic * rrand(0.9, 1.1),
##|     attack: 0.0025 * rrand(0.9, 1.1)
##| end

