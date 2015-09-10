## Tuned Ring Mod & Resonator in C minor
## Coded by Nanomancer

set_volume! 3
set_sched_ahead_time! 6
use_cue_logging true
notes = chord(:c1, :minor, num_octaves: 2).shuffle
#notes = scale(:c1, :hungarian_minor)
puts notes

live_loop :ambi do

  #cue :none
  frq = midi_to_hz(notes.tick)
  del = 1.0 / frq
  with_fx :reverb, mix: 0.5, room: 0.7 do
    with_fx :lpf, cutoff: 100 do
      #with_fx :ring_mod, freq: frq do
      with_fx :slicer, phase: [0.25, 0.5, 0.75, 1, 1.5, 2].choose do
        2.times do
          with_fx :echo, amp: 0.225, mix: 0.5, phase: del, decay: 1 do
            sample :ambi_haunted_hum, pan: -0.5, amp: 0.3, rate: (ring -0.5, -0.25, -1).tick(:tock)
            sleep 12
          end
          sleep 16
        end
        #end
      end
    end
  end
end

live_loop :choiron do

  #sync :none
  tick_set 2
  frq = midi_to_hz(notes.tick)
  del = (1.0 / frq) * 2
  with_fx :reverb, mix: 0.5, room: 0.7 do
    with_fx :echo, amp: 0.25, mix: 0.5, phase: del, decay: 2 do
      #with_fx :ring_mod, freq: frq do
      with_fx :slicer, mix: 0.5, phase: [0.25, 0.5, 0.75].choose do

        2.times do
          sample :ambi_choir, pan: 0.5, amp: 0.2, rate: (ring -1, 0.5, -2, -0.5, 1).tick(:ambi)
          sleep 6
        end
        sleep 6
      end
    end
    #end
  end
end

live_loop :lunar do

  #sync :none
  tick_set 3
  frq = midi_to_hz(notes.tick)
  del = (1.0 / frq) * 2
  with_fx :reverb, mix: 0.5, room: 0.7 do
    with_fx :bitcrusher, bits: 12 do
      with_fx :slicer, mix: 0.75, phase: (ring 0.5, 0.25, 0.75, 1).tick(:ambi) do

        2.times do
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.1, rate: (ring -1, -2, -0.5).look(:ambi)
          sleep [8, 4, 16].ring.look(:ambi)
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.1, rate: (ring 1, 2, 0.5).look(:ambi)
          sleep 16
        end
        sleep 12
      end
    end
  end
end

live_loop :sine_bass do

  use_synth :sine
  #  n = (knit :c2, 3, :ds2, 1)
  n = (knit :c2, 4, :ds2, 1, :f2, 1)
  play n.tick, amp: 0.3, decay: 0.75, sustain_level: 0.5, sustain: 0.75, release: 1#, cutoff: 80
  sleep 4
end

live_loop :blader do

  use_synth :blade
  with_fx :echo, phase: 2, decay: 4 do
    play 48 + notes.tick, amp: 0.06, attack: 2, sustain: 1, release: 3, cutoff: 85
    sleep [6, 10, 12, 6, 14, 6].ring.look
  end
end
live_loop :ticker do
  sample :elec_tick, amp: 0.09, cutoff: 75, res: 0.1
  #  sleep 0.5
  sleep (knit 0.5, 2, 0.25, 2, 0.5, 2, 0.25, 1, 0.125, 2, 0.5, 2).ring.tick
end

live_loop :kick do

  4.times do
    sample :bd_pure, rate: 0.85
    #sleep 2
    sleep [1, 0.5, 1.5, 0.5, 0.5].ring.tick
  end
end
