# Pi in the Park #2 - Percussion & bass # Coded by Nanomancer
live_loop :Tabla, sync: :Plucker do
  len = get[:len]
  with_fx :reverb, reps: len * 4, mix: 0.6, room: 0.4, damp: 0.5 do
    clock = sync :tick
    x = clock[:val]
    
    if factor?(x, len * 1) ; sample :tabla_ghe1, amp: 1 end
    if  factor?(x + 2, len) ; sample :tabla_ke1, amp: 0.8 end # add ring of samples
    with_fx :echo, max_phase: 4, phase: 0.75, mix: 0.4, decay: 8 do
      if factor?(x + 5, len * 3) ; sample :tabla_dhec, amp: 0.55 end
    end
    if factor?(x + 3, len * 2) ; sample :tabla_na, amp: 0.8 end
  end
end

live_loop :someBass, sync: :Plucker do
  len = get[:len]
  with_fx :reverb, reps: len * 4, mix: 0.6, room: 0.4, damp: 0.5 do
    use_synth :fm
    clock = sync :tick
    x = clock[:val]
    if factor?(x, len * 1)
      play :c2, amp: [0.5,0.3].ring.tick * around_one(0.1),
        release: len * 0.5 * around_one(0.05),
        depth: [1.25, 1.5, 2].ring.look * around_one(0.1)
      play :c3, amp: [0.3, 0.45].ring.look * around_one(0.1),
        release: len * 0.2 * around_one(0.1),
        depth: [1, 1.25].ring.look * around_one(0.1)
    end
  end
end