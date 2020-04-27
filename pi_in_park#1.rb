# Plucking Pi in the Park #1
# Coded by Nanomancer

set :cellz, [
  [ 0, 0, 1, 0, ].ring,
  [ 3, 9, 10, 3 ].ring,
  [ 3, 1, 1, 6 ].ring,
  [ 2, 5, 8, 10 ].ring,
].ring
set :hira_c3_1, (scale :c3, :hirajoshi, num_octaves: 1 )
set :hira_c3_2, (scale :c3, :hirajoshi, num_octaves: 2 )


live_loop :pluck do
  cellz = get[:cellz]
  notes = get[:hira_c3_2]
  rate = 2
  with_fx :reverb, mix: 0.6, room: 0.4, damp: 0.5 do
    use_synth :pluck
    row = tick
    column = look(:col)
    timingVariance = rand_1(0.075)
    if factor?(look, 11) then tick(:col) end
    ##| if one_in 6 then tick end
    ##| if one_in 6 then tick(:col) end
    play notes[ cellz[ column ][ row ] ],
      amp: 1 * rand_1(0.1)
    sleep rate * timingVariance * [0.25, 0.25, 0.25, 0.125, ].ring.look
    ##| sleep rate * timingVariance * [0.25, 0.25, 0.25, 0.125, 0.125].ring.look
    ##| sleep rate * timingVariance * [0.25, 0.25, 0.125, 0.125, 0.25, 0.25, 0.125, 0.125].ring.look * rand_1(0.04)
  end
end