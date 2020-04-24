live_loop :resonator do

  notes = chord(:c2, :minor, num_octaves: 2).shuffle

  frq = midi_to_hz(notes.tick)
  #phaseRate = 1 / frq
  phaseRate = 1.0 / frq
  puts phaseRate
  
  with_fx :echo, amp: 0.5, mix: 0.85, phase: phaseRate, decay: 2 do
    sample :bd_haus, amp: 0.5
    sleep 0.5
  end
end
