# Sequencer / arp based on multiple Euclidean distributions
# Coded by Nanomancer

use_bpm 120
set :pat1, spread(3,8)
set :pat2, spread(2,7)
set :pat3, spread(3,10)
##| set :pat4, spread(8,12)
##| set :pat4, spread(9,12)
##| set :pat4, spread(10,12)
##| set :pat4, spread(11,12)
set :pat4, spread(9,16)
set :pat4, spread(11,16)
set :pat4, spread(13,16)
set :pat4, spread(15,16)

##| set :dynamics, [1, 0.75, 0.9, 0.6, 0.44].ring
set :dynamics, [1, 0.75, 0.9, 0.6, ].ring

live_loop :euclideanSequencer do
  use_synth :prophet
  ##| notes = ( chord :c2,'m7+9', num_octaves: 2 )
  notes = ( scale :c2, :hirajoshi, num_octaves: 2 )
  root = 0
  pat4 = get[:pat4]
  tick_reset
  16.times do
    currentDegree = root
    clock = tick(step: 1)
    ##| clock = tick(step: 2)
    ##| clock = tick(step: -1)
    ##| clock = tick(step: -3)
    ##| clock = tick(step: 3)
    if get[:pat1][clock + 2] then currentDegree = 7 end
    if get[:pat2][clock + 2] then currentDegree -= 1 end
    if get[:pat3][clock + 4] then currentDegree = 5 end
    
    ##| if get[:pat1][clock + 4] then currentDegree -= 2 end
    
    if pat4[clock] then play notes[currentDegree],
        amp: get[:dynamics][clock]
      ##| cutoff: rand_i(65..75)
    end
    
    sleep 0.25
  end
end