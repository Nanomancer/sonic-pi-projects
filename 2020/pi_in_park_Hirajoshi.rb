# Pi in the Park #1 - hirajoshi and cellz
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
set :hira_c4_1, (scale :c4, :hirajoshi, num_octaves: 1 )
##| set :rhythm, [0.25, 0.25, 0.25, 0.125, ].ring
##| set :rhythm, [0.25, 0.25, 0.25, 0.125, 0.125].ring
set :rhythm, [0.25, 0.25, 0.125, 0.125, 0.25, 0.25, 0.125, 0.125].ring
set :dynamics, [1, 0.36, 0.66, 0.9, 0.5 ].ring
with_fx :echo, phase: 2.75, mix: 0.7, decay: 8 do
  live_loop :pluck do
    use_synth :pluck
    dynamics = get[:dynamics]
    cellz = get[:cellz]
    notes = get[:hira_c4_1]
    rhythm = get[:rhythm]
    with_fx :reverb, reps: ( 2 * rhythm.size() ), mix: 0.6, room: 0.4, damp: 0.5 do
      across = tick(step: 1)
      down = look(:down)
      timingVariance = rand_1(0.085)
      if factor?( across, 8 ) then tick(:down) end
      if one_in 3 then tick end
      if one_in 7 then tick(:col) end
      play notes[ cellz[ down ][ across ] ], amp: 0.01 * rand_1(0.1) * dynamics[ across ]
      
      sleep 2 * timingVariance * rhythm[across]
    end
  end
end
