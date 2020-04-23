use_bpm 120

snares = 3
beats = 8

live_loop :euClockean do
  puts "Beat #: #{look}"
  if look % 7 == 0 && look != 0 
    tick_set 1
    puts "modulo"
  end
  if spread(snares, beats).look
    puts "snare"
    sample :drum_snare_soft, amp: 0.3
  end
  if look == 1
    puts "kick"
    sample :bd_gas, amp: 0.3
  end
  sample :drum_cymbal_closed, amp: 0.5
  sleep 1
  tick
end