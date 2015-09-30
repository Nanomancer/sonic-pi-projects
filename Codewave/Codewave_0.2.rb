## Codewave_0.2 -Tuned Resonators in C minor
## Coded by Nanomancer

define :autosync do |id, num = 0|
  return sync id if tick(:as) == num
end


define :mk_rand_scale do |scale, len = 8|
  rand_s = []
  len.times do
    rand_s << scale.choose
  end
  return rand_s.ring
end

#######################
use_bpm 60
set_volume! 3
set_sched_ahead_time! 3
use_cue_logging true

##############  FX  #########################

live_loop :pulsar do
  cue :hum
  cue :drn
  # cue :fx
  cue :run

  autosync(:pulse)
  use_synth :growl
  cut = [70, 75, 80, 85, 90, 85, 80, 75].ring.tick(:cut)
  notes = (knit :c3, 2, :ds3, 1, :c3, 1)
  #notes = (knit :c3, 3, :ds3, 1, :c3, 1, :b2, 1)

  #notes = (knit :c3, 4, :ds3, 1, :b2, 1)
  with_fx :reverb, mix: 0.3, room: 0.3, amp: 1 do
    notes.size.times do
      play notes.tick, amp: 0.04, attack: 1, sustain: 1, release: 2, cutoff: cut
      sleep 8
    end
  end
  # stop
end

live_loop :res_hum do

  autosync(:hum)
  #notes = chord([:c1, :c2, :c3].choose, :minor, num_octaves: 2).shuffle
  # notes = scale(:c1, :hungarian_minor, num_octaves: 2).shuffle
  notes = scale(:c1, :harmonic_minor, num_octaves: 2).shuffle

  vol = 0.5

  #2.times do
  notes.size.times do

    with_fx :reverb, mix: [0.5, 0.6, 0.7, 0.8].choose, room: [0.6, 0.7, 0.8].choose do
      with_fx :compressor, threshold:  0.4 do
        with_fx :lpf, cutoff: [70, 75, 80, 85].choose do
          phase = [0.25, 0.5, 0.75, 1, 1.5, 2].choose

          with_fx :slicer, mix: [1, 0.75, 0.5, 0.25].choose, smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do

            frq = midi_to_hz(notes.tick)
            with_fx :echo, amp: 0.3, mix: 0.85, phase: 1.0 / frq, decay: 2 do
              sample :ambi_haunted_hum, beat_stretch: 4, pan: -0.6, amp: vol, rate: (ring -0.25, 0.5, 0.25).tick(:ambi)
            end
            sleep [16, 8, 16].ring.look(:ambi)

            frq = midi_to_hz(notes.tick)
            with_fx :echo, amp: 0.3, mix: 0.85, phase: 1.0 / frq, decay: 2 do
              sample :ambi_haunted_hum, beat_stretch: 4, pan: 0.6, amp: vol, rate: (ring 0.25, -0.5, -0.25).look(:ambi)
            end
            sleep [16, 8, 16].ring.look(:ambi)
          end
          sleep [4, 6, 8, 12, 16].choose
        end
      end
    end
  end
  #stop
end

live_loop :runner do

  autosync(:run)
  use_synth :blade
  chd = chord(:c1, :minor, num_octaves: 2).shuffle

  # scl = scale([:c4, :c5, :c6].choose, :humgarian_minor, num_octaves: 1)
  scl = scale([:c4, :c5, :c6].choose, :harmonic_minor, num_octaves: 1)
  2.times do
    notes = mk_rand_scale(scl, 3)
    puts "Runner scale: #{notes}"
    #slp = [6, 10, 6, 8, 12, 6, 6, 8, 6, 18, 6, 8, 6, 14, 6, 8, 6, 32].ring
    #slp = [6, 4, 6, 6, 2, 4, 2, 2, 8, 12, 8, 8, 16, 24, 16, 16].ring #6, 2, 8, 10, 6, 4, 4, 4, 8, 4, 8, 6, 8, 16].ring
    #slp = [6, 4, 6, 6, 2, 4, 2, 2, 8, 12, 8, 8, 16, 24, 16, 16].ring
    slp = [3,3,2].ring#,3,2,2,2,4].ring
    puts "sleepsize: #{slp.size}"
    (slp.size * 2).times do
      att, sus, rel = slp.tick * 0.3, slp.look * 0.2, slp.look * 0.5
      phase = [0.25, 0.5, 0.75, 1].choose
      # with_fx :reverb do
      with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
        with_fx :ring_mod, freq: rdist(0.0125, 0.5) * midi_to_hz(chd.tick(:chd)) do
          with_fx :slicer, mix: [0.9, 0.5, 0.25, 0.125].choose, smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
            #play notes.tick, amp: 0.025, attack: 2, sustain: 1, release: 3, cutoff: 85
            #play notes.tick, amp: 0.018, attack: 2, sustain: 1, release: 3, cutoff: 85
            play notes.look, amp: 0.01, attack: att, sustain: sus, release: rel, cutoff: 85
            puts "Runner sleep: #{slp.look}"
            sleep slp.look# * [1, 2, 4].choose
          end
        end
      end
      # end
      #stop
    end
    # sleep [2, 4, 6, 8, 10, 12, 14, 16, 24, 32].choose
  end
  sleep [4, 8, 12, 16].choose
end

live_loop :drone do
  #tick reset(:as)
  autosync(:drn)
  # cue :pulse
  scl = scale([:c5].choose, :harmonic_minor, num_octaves: 1)
  # scl = chord([:c1, :c2, :c3].choose, :minor, num_octaves: 2)
  notes = mk_rand_scale(scl, 4)

  puts "Dronescale: #{notes}"
  (notes.size * 2).times do
    frq = midi_to_hz(notes.tick)
    del = (1.0 / frq)# * 2
    with_fx :echo, amp: 0.4, mix: 1, phase: del, decay: 2 do
      sample :ambi_drone, attack: 0.6, pan: 0, amp: 0.5, rate: 0.5 # (ring 0.25, 0.5).tick(:ambi)
      sleep 8
    end
  end
  #stop
end

live_loop :lunar_sweep do

  #cue :drum
  autosync(:fx)
  with_fx :reverb, mix: 0.5, room: 0.4 do
    with_fx :bitcrusher, bits: [12, 14].choose, sample_rate: [4000, 8000, 12000].choose do

      2.times do
        with_fx :slicer, smooth_up: 0.125, mix: 0.75, phase: (ring 0.5, 0.25, 0.75, 1).tick do
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.05, rate: (ring -1, -2, -0.5).look
          sleep [8, 4, 16].ring.look
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.05, rate: (ring 1, 2, 0.5).look
          sleep 16
        end
        sleep 24
      end
    end
  end
  #stop
end

##############  DRUMS  #########################

# live_loop :kick do

#   autosync(:drum)
#   cue :drum
#   cue :syn
#   #slp = (knit 4,4)
#   slp = (ring 1, 0.5, 1.5, 0.5, 0.5)

#   8.times do
#     slp.size.times do
#       sample :bd_pure, rate: 0.85 * rdist(0.008, 1), amp: 0.8
#       sleep slp.tick
#     end
#   end
#   #stop
# end


# live_loop :brush do

#   autosync(:drum)
#   #slp = (knit 0.5, 32)
#   slp = (knit 0.5, 2, 0.25, 2, 0.5, 2, 0.25, 1, 0.125, 2, 0.5, 2)
#   8.times do
#     slp.size.times do
#       sample :elec_cymbal, rate: 4 * rdist(0.008, 1), amp: 0.077, attack: 0.0275, cutoff: 90, res: 0.1, pan: -0.25
#       sleep slp.tick
#     end
#   end
#   #stop
# end


# live_loop :pale_rider do

#   autosync(:drum)
#   10.times do
#     sample :drum_cymbal_soft, rate: [0.8, 0.65].choose * rdist(0.008, 1), amp: 0.04, pan: 0.25
#     sleep (knit 16, 2, 4, 4, 8, 2, 2, 2, ).tick
#   end
#   #stop
# end


##############  SYNTHS  #########################

# live_loop :sine_bass do ## sine amp- 0.225 & 0.08

#   autosync(:drum)
#   use_synth :sine
#   #notes = (knit :c2, 3, :ds2, 1)
#   notes = (knit :c2, 4, :ds2, 1, :f2, 1)
#   cut = [75, 80, 85, 90, 85, 80, 75].ring
#   notes.size.times do
#     play notes.tick, amp: 0.2, decay: 0.75, sustain_level: 0.5, sustain: 0.75, release: 1#, cutoff: 75
#     #synth :prophet, note: notes.look, amp: 0.035, decay: 1, sustain_level: 0.6, sustain: 2, release: 1, cutoff: cut.tick(:ctick)
#     sleep 4
#   end
#   #stop
# end


##
