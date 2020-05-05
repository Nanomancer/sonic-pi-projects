# Pi in the Park #1 - hirajoshi and cellz # Coded by Nanomancer

set_volume! 4
set :cellz, [
  [ 0, 0, 1, 0, ].ring,
  [ 3, 9, 10, 3 ].ring,
  [ 4, 1, 12, 6 ].ring,
  [ 2, 5, 8, 7 ].ring,
].ring
set :timingVariance, rand_1(0.0575)
##| set :hira, (scale :c3, :hirajoshi, num_octaves: 1 )
set :hira, (scale :c3, :hirajoshi, num_octaves: 2 )
##| set :hira, (scale :c4, :hirajoshi, num_octaves: 1 )
set :rhythm, [ 0.25, 0.25, 0.25, 0.125, ].ring
set :rhythm, [0.25, 0.25, 0.25, 0.125, 0.125].ring
##| set :rhythm, [0.25, 0.125, 0.25, 0.125, ].ring
##| set :rhythm, [0.125, 0.25, 0.25, 0.125, 0.125, 0.125].ring
##| set :rhythm, [0.25, 0.25, 0.125, 0.125, 0.25, 0.25, 0.125, 0.125].ring
set :dynamics, [1, 0.33, 0.66, 0.9, 0.51 ].ring
set :tone, [0.4, 0.7, 0.5, 0.65].ring
##| set :tone, [0.45, 0.5, 0.33].ring

live_loop :pluckAndTabla do
  ##| with_fx :echo, max_phase: 4, phase: 2.5, mix: 0.3, decay: 3 do
  use_synth :pluck
  dynamics = get[:dynamics]
  cellz = get[:cellz]
  notes = get[:hira]
  rhythm = get[:rhythm]
  len = rhythm.size()
  with_fx :reverb, reps: len * 2, mix: 0.6, room: 0.4, damp: 0.5 do
    x = tick(:x, step: 1)
    y = look(:y)
    
    if factor?(x, len) then sample [:tabla_ke1, :tabla_ke2, :tabla_ke3].ring.tick end
    if factor?(x, len * 3) then sample :tabla_dhec, amp: 0.6 end
    if factor?(x, 3 + len * 2) then sample :tabla_na, amp: 0.8 end
    if factor?(x, len * 4) then sample :tabla_ghe1, amp: 1 end
    
    ##| if one_in 15 then tick(:x) end
    ##| if one_in 10 then tick(:y) end
    
    play notes[ cellz[ y ][ x ] ],
      amp: 1 * rand_1(0.1) * dynamics[ x ],
      coef: get[:tone][ x ]
    sleep 1.30 * get[:timingVariance] * rhythm[ x ]
    if factor?( x, 0 + len * 2) then tick(:y) end
  end
end
##| end
