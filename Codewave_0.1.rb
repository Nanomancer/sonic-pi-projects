## Codewave_0.1 -Tuned Ring Mods & Resonators in C minor
## Coded by Nanomancer
## Copyright James A. Smith
##

set_volume! 3
set_sched_ahead_time! 3
use_cue_logging true
#notes = chord(:c1, :minor, num_octaves: 2).shuffle

live_loop :resonatrix do

  #cue :fx
  #cue :synths
  cue :drums

  notes = chord([:c1, :c2].choose, :minor, num_octaves: 2).shuffle
  2.times do
    with_fx :reverb, mix: 0.5, room: 0.7 do
      with_fx :lpf, cutoff: 100 do
        2.times do

          with_fx :slicer, smooth_up: 0.125, smooth_down: 0.05, phase: [0.25, 0.5, 0.75, 1, 1.5, 2].choose do

            frq = midi_to_hz(notes.tick)
            with_fx :echo, amp: 0.3, mix: 0.85, phase: 1.0 / frq, decay: 2 do
              sample :ambi_haunted_hum, beat_stretch: 4, pan: -0.6, amp: 0.35, rate: (ring -0.25, 0.5, -1, 0.25, -2).tick(:ambi)
            end
            sleep [16, 8, 4, 16, 2].ring.look(:ambi)

            frq = midi_to_hz(notes.tick)
            with_fx :echo, amp: 0.3, mix: 0.85, phase: 1.0 / frq, decay: 2 do
              sample :ambi_haunted_hum, beat_stretch: 4, pan: 0.6, amp: 0.35, rate: (ring 0.25, -0.5, 1, -0.25, 2).look(:ambi)
            end
            sleep [16, 8, 4, 16, 2].ring.look(:ambi)
            #tick
          end
          #sleep 8
        end
      end
    end
  end
  #stop
end

live_loop :choir do
  notes = chord(:c1, :minor, num_octaves: 2).shuffle
  #sync :fx
  4.times do
    frq = midi_to_hz(notes.tick)
    del = (1.0 / frq)# * 2
    with_fx :reverb, mix: 0.5, room: 0.7 do
      with_fx :echo, amp: 0.25, mix: 0.5, phase: del, decay: 2 do
        #with_fx :ring_mod, freq: frq do
        #with_fx :slicer, mix: 0.35, phase: [0.25, 0.5, 0.75].choose do

        2.times do
          sample :ambi_choir, pan: [1, 0, -1].choose, amp: 0.1, rate: (ring 0.25, -0.33, 0.5, -0.66, -1).tick(:ambi)
          sleep 6
        end
        #sleep 6
        #end
      end
      #end
    end
  end
end

live_loop :lunar_sweep do

  sync :fx
  with_fx :reverb, mix: 0.5, room: 0.7 do
    with_fx :bitcrusher, bits: [10, 12, 14].choose do

      2.times do
        with_fx :slicer, smooth_up: 0.125, mix: 0.75, phase: (ring 0.5, 0.25, 0.75, 1).tick(:ambi) do
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.08, rate: (ring -1, -2, -0.5).look(:ambi)
          sleep [8, 4, 16].ring.look(:ambi)
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.08, rate: (ring 1, 2, 0.5).look(:ambi)
          sleep 16
        end
        sleep 12
      end
    end
  end
end

live_loop :kick do

  sync :drums
  #cue :drums

  32.times do
    sample :bd_pure, rate: 0.85 * rdist(0.008, 1), amp: 0.9
    sleep 4
    #sleep [1, 0.5, 1.5, 0.5, 0.5].ring.tick
  end
  #stop
end

live_loop :brush do

  sync :n
  64.times do
    sample :elec_cymbal, rate: 4 * rdist(0.008, 1), amp: 0.075, attack: 0.0275, cutoff: 85, res: 0.1, pan: -0.25
    sleep 1
    #sleep (knit 0.5, 2, 0.25, 2, 0.5, 2, 0.25, 1, 0.125, 2, 0.5, 2).ring.tick
  end
end

live_loop :pale_rider do

  sync :n
  #sync :drums

  4.times do
    sample :drum_cymbal_soft, rate: [0.8, 0.65].choose * rdist(0.008, 1), amp: 0.04, pan: 0.25
    sleep (knit 4, 2, 8, 2, 2, 2, 16, 2).tick
  end
end

live_loop :sine_bass do
  sync :n
  use_synth :sine
  #  n = (knit :c2, 3, :ds2, 1)
  n = (knit :c2, 4, :ds2, 1, :f2, 1)
  4.times do
    play n.tick, amp: 0.15, decay: 0.75, sustain_level: 0.5, sustain: 0.75, release: 1#, cutoff: 80
    sleep 4
  end
  #stop
end

live_loop :runner do

  sync :n
  use_synth :blade
  notes = chord(:c3, :minor, num_octaves: 3).shuffle
  4.times do
    with_fx :echo, phase: 2, decay: 4 do
      play notes.tick, amp: 0.04, attack: 2, sustain: 1, release: 3, cutoff: 85
      sleep [6, 10, 12, 6, 14, 6].ring.look
    end
  end
end

##
