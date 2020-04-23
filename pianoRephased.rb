# Steve Reich's Piano Phase
# Rephased By Nanomancer

use_bpm 120
set_volume! 3
use_synth :fm
set_sched_ahead_time! 2

notes = (ring :E4, :Fs4, :B4, :Cs5, :D5, :Fs4, :E4, :Cs5, :B4, :Fs4, :D5, :Cs5)
randAmt = 0.035
randHigh = 1 + randAmt
randLow = 1 - randAmt

define :mainDrum do | time |
  sample :bd_haus, amp: rrand(randLow, randHigh) * [0.9, 0.65, 0.8, 0.7].ring.tick, cutoff: [106, 97, 105, 99, 104, 98].ring.look
  sample :bd_klub, amp: rrand(randLow, randHigh) * [0.9, 0.65, 0.8, 0.7].ring.look, cutoff: [100, 99, 101, 98, 103, 97, 101, 99].ring.look
  sleep 0.5 * time
  sample :drum_cymbal_closed, amp: rrand(randLow, randHigh) * [0.85, 0.76, 0.88, 0.7].ring.look, cutoff: [130, 127, 129, 128, 130, 128].ring.look
  sleep 0.5 * time
end

define :filldrum do | time |
  tick_reset
  2.times do
    
    tick
    
    sample :drum_cymbal_closed, amp: rrand(randLow, randHigh) * [0.85, 0.76, 0.88, 0.7].ring.look
    
    if look == 0
      sample :bd_haus, amp: rrand(randLow, randHigh) * [0.8, 0.6, 0.65, 0.55].ring.look, cutoff: [103, 97, 100, 99, 101, 98].ring.look
      sample :bd_klub, amp: rrand(randLow, randHigh) * [0.9, 0.65, 0.8, 0.7].ring.look, cutoff: [100, 99, 101, 98, 103, 97, 101, 99].ring.look
    end
    sleep 0.5 * time
  end
end
################################################################################################

live_loop :sendClock do
  tick
  if look == 0
    midi_start
    puts "look value: #{look}"
  end
  midi_clock_beat
  sleep 1
end

with_fx :reverb, room: 0.4, damp: 0.6, mix: 0.4 do
  live_loop :drums do
    sample :elec_cymbal, amp: 0.15 * rrand(randLow, randHigh)
    22.times do
      mainDrum(1)
    end
    sample :drum_cymbal_open, amp: 0.2 * rrand(randLow, randHigh)
    2.times do
      filldrum(1)
    end
  end
end

sleep 48
with_fx :echo, decay: 8, phase: 0.75 do |fx|
  with_fx :reverb, room: 0.8, damp: 0.3, mix: 0.5 do
    
    live_loop :constant do
      24.times do
        play notes.tick, pan: -0.4,
          amp: 0.65 * rrand(randLow, randHigh) * [0.85, 0.35, 0.7, 0.5, 0.8, 0.4, 0.6, 0.4].ring.look,
          release: [0.5, 0.75, 0.5, 1, 0.25].ring.look * rrand(randLow, randHigh) *0.5,
          divisor: [2, 1, 0.5, 1, 0.5, 1, 2, 1, 0.5, 1, 0.25, 1].ring.look,
          depth: [1, 2, 3, 1, 2, 3, 2, 4].ring.look,
          cutoff: [80, 100, 90, 110, 130, 120, 115].ring.look,
          attack: [0.001,0.0012,0.0015].ring.look
        sleep 1
      end
      tick_reset
    end
    sleep 48
    current = 0
    offset = 0
    delay = 0.75
    live_loop :phased do
      4.times do
        count = 0
        12.times do
          count += 1
          puts "Phase #: #{count}, total offset: #{count + current - 1}, echo: #{delay}"
          24.times do
            play notes.tick, pan: 0.4,
              amp: 0.45 * rrand(randLow, randHigh) * [0.9, 0.45, 0.7, 0.4, 0.2].ring.look,
              release: [0.5, 0.75, 1].ring.look * rrand(randLow, randHigh)*0.6,
              divisor: [2,1,1,2,1,0.5].ring.look,
              depth: [1, 2, 1, 1, 4, 2, 3].ring.look,
              cutoff: [100, 90, 110, 130, 120].ring.look,
              attack: [0.001,0.0012,0.0015,0, 0.0015].ring.look
            sleep 1
          end
          tick
        end
        offset = 0.25
        current = current + offset
        sleep 0.25
        puts "Applying offset: #{current}"
      end
      delay = delay + 0.75
      control fx, phase: delay
    end
    
  end
end

with_fx :echo, decay: 4, phase: 2, mix: 0.4 do
  live_loop :perc do
    sleep 48
    96.times do
      sleep 0.5
      if spread(3,8).tick
        sample :sn_generic, rate: 1.5, amp: rrand(randLow, randHigh) * [0.33, 0.36, 0.3, 0.39].ring.look,
          cutoff: rrand(randLow, randHigh) * [90, 105, 95, 110, 100].ring.look
        
      end
    end
  end
end
