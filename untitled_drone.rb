## Untitled Drone - Coded by Nanomancer

live_loop :dronetest do
  use_synth :zawa
  with_fx :reverb do
    play :e1, attack: 2, sustain: 16, cutoff: 62, res: 0.5, phase: 8, range: 24, wave: 2
    sleep 16
  end
end

live_loop :dronetest2 do
  use_synth :zawa
  with_fx :reverb do
    play :g3, attack: 2, sustain: 16, cutoff: 75, res: 0.5, phase: 4, range: 24, wave: 2, amp: 0.5
    sleep 8
  end
end

live_loop :dronetest2 do
  use_synth :zawa
  with_fx :reverb do
    play :b2, attack: 2, sustain: 16, cutoff: 65, res: 0.5, phase: 16, range: 24, wave: 2, amp: 0.5
    sleep 16
  end
end

# live_loop :ambirub do
#   sample :ambi_glass_rub, rate: 0.5, amp: 0.35, attack: 1
#   sleep 16
# end

# live_loop :gut do
#   sleep 4
#   sample :guit_e_fifths, amp: 0.3
#   sleep 4
# end
