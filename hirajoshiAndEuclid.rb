# Sequencer / arp based on multiple Euclidean distributions
# Coded by Nanomancer

use_bpm 120

live_loop :EBM, sync: :clock do
  pattern_1, pattern_2, pattern_3 = spread( 3, 8 ), spread( 2, 7 ), spread( 3, 10 )
  use_synth :prophet
  ##| 2.times do
  (get[:editQuantisation]).times do
    tick_reset
    #################################
    ##| notes = ( chord :c2,'m7+9', num_octaves: 2 )
    notes = (scale :c2, :hirajoshi, num_octaves: 2)
    root = 0
    ##| noteTriggerPattern = spread(8, 12)
    ##| noteTriggerPattern = spread(9, 12)
    ##| noteTriggerPattern = spread(10, 12)
    ##| noteTriggerPattern = spread(11, 12)
    ##| noteTriggerPattern = spread(9, 16)
    ##| noteTriggerPattern = spread(11, 16)
    ##| noteTriggerPattern = spread(13, 16)
    noteTriggerPattern = spread(15, 16)
    ##| dynamicPattern = [1, 0.75, 0.9, 0.6, 0.44].ring
    dynamicPattern = [1, 0.75, 0.9, 0.6].ring
    16.times do
      currentDegree = root
      
      clock = tick(step: 1) ##| clock steps - # 1 / -1 / 2 / 3 / -3
      
      if pattern_1[clock + 2] then currentDegree = 7 end
      if pattern_2[clock + 2] then currentDegree -= 1 end
      if pattern_3[clock + 4] then currentDegree = 5 end
      ##| if pattern_1[clock + 4] then currentDegree -= 2 end
      
      if noteTriggerPattern[clock] then play notes[currentDegree],
          amp: dynamicPattern[clock],
          ##| cutoff: 92
          cutoff: [100, 90, 105, 88, 110].ring.look * 0.99
      end
      sleep 0.25
    end
  end
  
end

live_loop :clock, cue: id do | idx |
  ##| puts cue("/live_loop/clock")
  puts idx
  4.times do
    sleep 1
  end
  idx + 1
end