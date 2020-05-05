# Pi in the Park #2 - Melody / pluck # Coded by Nanomancer
set_volume! 4
set :timingVariance, rand_1(0.0575)
set :arrays, [
  [ 0, 0, 1, 0, ].ring,
  [ 3, 9, 10, 3 ].ring,
  [ 4, 1, 12, 6 ].ring,
  [ 2, 5, 8, 7 ].ring,
].ring

##| set :hira, (scale :c3, :hirajoshi, num_octaves: 2 )
set :hira, (scale :c4, :hirajoshi, num_octaves: 1 )
set :rhythm, [ 0.25, 0.25, 0.25, 0.125, ].ring
set :rhythm, [0.25, 0.25, 0.25, 0.125, 0.125].ring
set :rhythm, [0.25, 0.125, 0.25, 0.125, ].ring
##| set :rhythm, [0.125, 0.25, 0.25, 0.125, 0.125, 0.125].ring
set :rhythm, [0.25, 0.25, 0.25, 0.25, 0.125, 0.125, 0.125, 0.125].ring
set :dynamics, [1, 0.33, 0.66, 0.9, 0.51 ].ring
set :tone, [0.4, 0.7, 0.5, 0.65].ring
##| set :tone, [0.45, 0.5, 0.33].ring
set :len, get[:rhythm].size()

live_loop :Plucker do
  use_synth :pluck
  dynamics = get[:dynamics]
  arrays = get[:arrays]
  notes = get[:hira]
  rhythm = get[:rhythm]
  len = get[:len]
  ##| if one_in 3 then tick(:x) end
  ##| if one_in 4 then tick(:y) end
  with_fx :reverb, reps: len * 4, mix: 0.6, room: 0.4, damp: 0.5 do
    x = tick(:x, step: 1)
    y = look(:y)
    
    cue :tick, val: x
    
    play notes[ arrays[ y ][ x ] ],
      amp: 0.8 * around_one(0.1) * dynamics[ x ],
      coef: get[:tone][ x ]
    sleep 1.5 * get[:timingVariance] * rhythm[ x ]
    if factor?( x, 0 + len * 2) ; tick(:y, step: 1) end
  end
end
