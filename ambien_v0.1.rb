## Tuned Ring Mod & Resonator in C minor
## Coded by Nanomancer

use_cue_logging false
notes = chord(:c1, :minor, num_octaves: 2).shuffle
#notes = scale(:c1, :hungarian_minor)

puts notes

live_loop :ambi do
  #cue :none
  frq = midi_to_hz(notes.tick)
  del = 1.0 / frq
  with_fx :reverb, mix: 0.5, room: 0.7 do
    #with_fx :echo, phase: [0.5, 0.75, 1, 1.5].choose, decay: 2 do
    with_fx :lpf, cutoff: 110 do
      with_fx :echo, amp: 0.5, mix: 0.7, phase: del, decay: 1 do
        with_fx :ring_mod, freq: frq do
          with_fx :slicer, phase: [0.25, 0.5, 0.75].choose do
            2.times do
              sample :ambi_haunted_hum, amp: 0.4, rate: (ring -0.5, -0.25, -1).tick(:tock)
              sleep 12
            end
          end
        end
      end
      #end
    end
  end
  #sleep 12
  #end
end

live_loop :choiron do
  #sync :none
  tick_set 2
  frq = midi_to_hz(notes.tick)
  del = (1.0 / frq) * 2
  with_fx :reverb do
    #with_fx :echo, phase: [0.5, 0.75, 1, 1.5].choose, decay: 4 do
    with_fx :echo, amp: 0.25, mix: 0.5, phase: del, decay: 2 do
      with_fx :ring_mod, freq: frq do
        with_fx :slicer, phase: [0.25, 0.5, 0.75].choose do

          4.times do
            sample :ambi_choir, amp: 0.3, rate: (ring 0.5, -1, -0.5).tick(:ambi)
            sleep 4
          end
          sleep 4
        end
      end
      #end
    end
  end
end

live_loop :bass do

  use_synth :sine
  n = (knit :c2, 3, :ds2, 1, :f2, 1, :c2, 1)
  play n.tick, amp: 0.25, decay: 0.75, sustain_level: 0.5, sustain: 0.75, release: 1#, cutoff: 80
  sleep 4
end

live_loop :blader do
  use_synth :blade
  with_fx :echo, phase: 2, decay: 4 do
    play 48 + notes.tick, amp: 0.075, attack: 2, sustain: 1, release: 2, cutoff: 85
    sleep [10, 12, 14].ring.look
  end
end

live_loop :perc do
    sample :bd_pure, rate: 0.85
    sleep [1, 0.5, 1.5, 0.5, 0.5].ring.tick
  end
