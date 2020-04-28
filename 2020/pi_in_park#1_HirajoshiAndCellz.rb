# Pi in the Park #1 - :hirajoshi and :cellz
# Coded by Nanomancer
set_volume! 3
set :cellz, [
  [ 0, 0, 1, 0, ].ring,
  [ 3, 9, 10, 3 ].ring,
  [ 3, 1, 1, 6 ].ring,
  [ 2, 5, 8, 10 ].ring,
].ring
set :hira_c3_1, (scale :c3, :hirajoshi, num_octaves: 1 )
set :hira_c3_2, (scale :c3, :hirajoshi, num_octaves: 2 )
set :rhythm, [0.25, 0.25, 0.25, 0.125, ].ring
##| set :rhythm, [0.25, 0.25, 0.25, 0.125, 0.125].ring
##| set :rhythm, [0.25, 0.25, 0.125, 0.125, 0.25, 0.25, 0.125, 0.125].ring

live_loop :pluck do
  use_synth :pluck
  cellz = get[:cellz]
  notes = get[:hira_c3_2]
  rhythm = get[:rhythm]
  with_fx :reverb, reps: ( 2 * rhythm.size() ), mix: 0.6, room: 0.4, damp: 0.5 do
    across = tick(step: 1)
    down = look(:down)
    timingVariance = rand_1(0.085)
    if factor?( across, 11 ) then tick(:down) end
    ##| if one_in 6 then tick end
    ##| if one_in 10 then tick(:col) end
    play notes[ cellz[ down ][ across ] ], amp: 0.5 * rand_1(0.1)
    
    sleep 2 * timingVariance * rhythm[across]
  end
end
