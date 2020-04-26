# Sequencer / arp based on multiple Euclidean distributions
# Coded by Nanomancer

use_bpm 120

live_loop :euclideanSequencer do
  use_synth :prophet
  #################################
  pattern_1 = get[:pattern_3_8]
  pattern_2 = get[:pattern_2_7]
  pattern_3 = get[:pattern_3_10]
  #################################

  ##| notes = ( chord :c2,'m7+9', num_octaves: 2 )
  notes = (scale :c2, :hirajoshi, num_octaves: 2)
  root = 0
  noteTriggerPattern = get[:pattern_15_16]

  ##| set :dynamics, [1, 0.75, 0.9, 0.6, 0.44].ring
  set :dynamicPattern, [1, 0.75, 0.9, 0.6].ring

  tick_reset
  16.times do
    currentDegree = root
    clock = tick(step: 1)

    ##| clock = tick(step: 2)
    ##| clock = tick(step: -1)
    ##| clock = tick(step: -3)
    ##| clock = tick(step: 3)
    if pattern_1[clock + 2] then currentDegree = 7 end
    if pattern_[clock + 2] then currentDegree -= 1 end
    if pattern_3[clock + 4] then currentDegree = 5 end
    ##| if pattern_1[clock + 4] then currentDegree -= 2 end

    if noteTriggerPattern[clock] then play notes[currentDegree],
                                           amp: get[:dynamics][clock]
 ##| cutoff: rand_i(65..75)
          end

    sleep 0.25
  end
end
