## Codewave_0.1 -Tuned Ring Mods & Resonators in C minor
## Coded by Nanomancer
## Copyright James A. Smith

define :syncer do |id|
  if look == 0
    return sync id
  end
end

#######################

set_volume! 3
set_sched_ahead_time! 3
use_cue_logging true

##############  FX  #########################

live_loop :res_hum do
  #cue :fx
  #cue :drum
  #cue :syn
  notes = chord([:c1, :c2].choose, :minor, num_octaves: 2).shuffle
  
  #2.times do
  
  with_fx :reverb, mix: [0.5, 0.6, 0.7, 0.8].choose, room: [0.6, 0.7, 0.8].choose do
    with_fx :lpf, cutoff: [80, 90, 100, 110].choose do
      2.times do

        #with_fx :slicer, smooth_up: 0.125, smooth_down: 0.05, phase: [0.25, 0.5, 0.75, 1, 1.5, 2].choose do

        frq = midi_to_hz(notes.tick)
        with_fx :echo, amp: 0.25, mix: 0.85, phase: 1.0 / frq, decay: 2 do
          sample :ambi_haunted_hum, beat_stretch: 4, pan: -0.6, amp: 0.3, rate: (ring -0.25, 0.5, -1, 0.25, -2).tick(:ambi)
        end
        sleep [16, 8, 4, 16, 2].ring.look(:ambi)

        frq = midi_to_hz(notes.tick)
        with_fx :echo, amp: 0.25, mix: 0.85, phase: 1.0 / frq, decay: 2 do
          sample :ambi_haunted_hum, beat_stretch: 4, pan: 0.6, amp: 0.3, rate: (ring 0.25, -0.5, 1, -0.25, 2).look(:ambi)
        end
        sleep [16, 8, 4, 16, 2].ring.look(:ambi)
        #end
        #sleep 8
      end
    end
  end
  #end
  #stop
end

live_loop :choir do

  syncer(:fx)
  notes = chord(:c1, :minor, num_octaves: 2).shuffle
  
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
        #sleep 4
        #end
      end
      #end
    end
  end
end

comment do
  live_loop :lunar_sweep do

    syncer(:fx)
    with_fx :reverb, mix: 0.5, room: 0.7 do
      with_fx :bitcrusher, bits: [8, 10, 12, 14].choose, sample_rate: [4000, 8000, 12000].choose do

        2.times do
          with_fx :slicer, smooth_up: 0.125, mix: 0.75, phase: (ring 0.5, 0.25, 0.75, 1).tick do
            sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.08, rate: (ring -1, -2, -0.5).look
            sleep [8, 4, 16].ring.look
            sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.08, rate: (ring 1, 2, 0.5).look
            sleep 16
          end
          sleep 12
        end
      end
    end
  end
end
##############  DRUMS  #########################


live_loop :kick do

  syncer(:drum)
  #cue :synth

  slp = (knit 4,4)
  #slp = (ring 1, 0.5, 1.5, 0.5, 0.5)
  
  8.times do
    slp.size.times do
      sample :bd_pure, rate: 0.85 * rdist(0.008, 1), amp: 0.8
      sleep slp.tick
    end
  end
end


comment do
  live_loop :brush do
  
    syncer(:drum)
    slp = (knit 1,16)
    #slp = (knit 0.5, 2, 0.25, 2, 0.5, 2, 0.25, 1, 0.125, 2, 0.5, 2)

    slp.size.times do
      sample :elec_cymbal, rate: 4 * rdist(0.008, 1), amp: 0.075, attack: 0.0275, cutoff: 85, res: 0.1, pan: -0.25
      sleep slp.tick
    end
  end
end

comment do
  live_loop :pale_rider do
  
    syncer(:drum)
    10.times do
      sample :drum_cymbal_soft, rate: [0.8, 0.65].choose * rdist(0.008, 1), amp: 0.04, pan: 0.25
      sleep (knit 16, 2, 4, 4, 8, 2, 2, 2, ).tick
    end
  end
end

##############  SYNTHS  #########################

live_loop :sine_bass do

  syncer(:syn)
  use_synth :sine
  #notes = (knit :c2, 3, :ds2, 1)
  notes = (knit :c2, 4, :ds2, 1, :f2, 1)
  notes.size.times do
    play notes.tick, amp: 0.2, decay: 0.75, sustain_level: 0.5, sustain: 0.75, release: 1#, cutoff: 80
    sleep 4
  end
end

comment do
  live_loop :runner do
    syncer(:syn)
    use_synth :blade
    notes = chord(:c3, :minor, num_octaves: 3).shuffle
    6.times do
      with_fx :echo, phase: 2, decay: 4 do
        play notes.tick, amp: 0.04, attack: 2, sustain: 1, release: 3, cutoff: 85
        sleep [6, 10, 12, 6, 14, 6].ring.look
      end
    end
  end
end

##
