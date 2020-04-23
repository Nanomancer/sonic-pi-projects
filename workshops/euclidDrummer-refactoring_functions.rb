
define :calculateYAxis do | m, x, c |
  """ Linear, Where m is gradient and c is y-intercept.
Where C is minimum value of the parameter to reduce -
You need to calculate gradient!
m = ( y2 - y1 ) / ( x2 - x1 )
dynamic input (x) should be value from an array intended
to be used for amp / velocity. 
"""
  y = ( m * x ) + c
  return y
end

define :calculateReduction do | valuesMap, aDynamic |
  randLow = 1 - valuesMap[:randAmount]
  modifier = calculateYAxis(valuesMap[:gradient], aDynamic, valuesMap[:y_int])
  return valuesMap[:maxValue] * rrand(randLow, 1.0) * modifier
end


define :playKick do | aDynamic, sample_1 = :bd_fat, sample_2 = :bd_sone |
  cutoffMap = {
    maxValue: 130,
    gradient: 0.6,
    y_int: 0.4,
    randAmount: 0.01
  }
  pitchMap = {
    maxValue: 1,
    gradient: 0.02,
    y_int: 0.98,
    randAmount: 0.0075
  }
  
  sample sample_1,
    cutoff: calculateReduction(cutoffMap, aDynamic),
    rate: calculateReduction(pitchMap, aDynamic),
    amp: 0.55 * aDynamic * rrand(0.96, 1.02)
  
  sample sample_2,
    cutoff: calculateReduction(cutoffMap, aDynamic),
    rate: calculateReduction(pitchMap, aDynamic),
    amp: 0.35 * aDynamic * rrand(0.97, 1.03)
  
end

live_loop :test do
  aDynamic = [1, 0.6, 0.85, 0.55, 0.95, 0.65, 0.9, 0.7].ring.tick
  playKick(aDynamic)
  sleep 0.5
end





















