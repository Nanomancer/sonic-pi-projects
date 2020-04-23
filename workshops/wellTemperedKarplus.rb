# Welcome to Sonic Pi v2

# The well-tempered karplus strong - Nanomancer

slp = 2
tonic = 220.0
set_volume! 3
ampLevel = 0.7
randLow = 0.85
randHigh = 1.15
pitchRandLow = 0.995
pitchRandHigh = 1.005
sample :elec_beep
puts "Sync"

# Hirajoshi
min3rd = 6.0 / 5
per5th = 3.0 / 2
#min7th = 9.0 / 5
maj2nd = 9.0 / 8
#per4th = 4.0 / 3
maj6th = 5.0 / 3

sleep 4

live_loop :drums do
  sample :drum_cymbal_closed , amp: [0.9, 0.5, 0.45, 0.6].ring.tick * 0.25 * rrand(randLow, randHigh)
  if look % 8 == 0 || look % 12 == 0
    sample :bd_pure, amp: [0.7, 0.45, 0.7, 0.5].ring.tick * rrand(randLow, randHigh)
  end
  sleep slp * 0.5
end

sleep 7
with_fx :echo, decay: slp * 8, phase: slp * 2 do
  with_fx :reverb, room: 0.9, damp: 0.1,  mix: 0.8 do
    use_synth :pluck
    
    live_loop :tonic do
      play hz_to_midi(tonic * rrand(pitchRandLow, pitchRandHigh)), amp: ampLevel * rrand(randLow, randHigh)
      sleep slp * [1,2,4,1,2,4, 8].ring.tick
    end
    
    live_loop :min3rd do
      sleep (slp * [8,1,2,4,1,2,4,2].ring.tick * min3rd)
      play hz_to_midi(tonic * rrand(pitchRandLow, pitchRandHigh) * min3rd), amp: ampLevel * rrand(randLow, randHigh)
    end
    
    live_loop :per5th do
      sleep (slp * [8,0.5,1,2,4,4,2,2,].ring.tick * per5th)
      play hz_to_midi(tonic * rrand(pitchRandLow, pitchRandHigh) * per5th), amp: ampLevel * rrand(randLow, randHigh)
    end
    
    live_loop :maj9th do
      sleep (slp * [8,1,2,4,1,2].ring.tick * maj2nd)
      play hz_to_midi(tonic * rrand(pitchRandLow, pitchRandHigh) * 2 * maj2nd), amp: ampLevel * rrand(randLow, randHigh)
    end
    
    live_loop :maj13th do
      sleep (slp * [8,1,2,4,0.5,2,1].ring.tick * maj6th)
      play hz_to_midi(tonic * rrand(pitchRandLow, pitchRandHigh) * 2 * maj6th), amp: ampLevel * rrand(randLow, randHigh)
    end
  end
end