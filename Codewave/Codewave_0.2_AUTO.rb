## Codewave_0.2 -Tuned Resonators in C minor
## Coded by Nanomancer


define :stopwatch do |int, max, fade|
  ## interval in seconds, max in mins
  count = 0
  set_mixer_control! amp: 1, amp_slide: 0.1
  with_bpm 60 do
    while count / 60.0 < max
      if count % int == 0
        puts "Time: #{count / 60.0} Minutes"
      end
      count += 1
      sleep 1
      $global_clock = count / 60.0
    end
    set_mixer_control! amp: 0.01, amp_slide: fade
    puts "Stopping - #{fade} sec fadeout"
  end
end

define :autosync do |id, num = 0|
  tick(:as)
  puts "Liveloop ID: #{id} | No: #{look(:as)}"
  return sync id if look(:as) == num
end

define :autostop do |time|
  return stop if $global_clock >= time
end

define :mk_rand_scale do |scale, len = 8|
  rand_s = []
  len.times do
    rand_s << scale.choose
  end
  return rand_s.ring
end

#######################

load_samples [:ambi_drone, :ambi_haunted_hum, :ambi_lunar_land]
$global_clock = 0
use_bpm 60
set_volume! 5
set_sched_ahead_time! 6
use_cue_logging false
SEED = Time.now.usec
puts "Epoch seed: #{SEED}"
# use_random_seed 220574 # 263020 # 746742 # 100
use_random_seed SEED # 746742 # 100

sleep 2
sample :elec_blip
puts "SYNC"
sleep 2
#############  CLOCK  #####################

in_thread do
  stopwatch(15, 5, 30)
end

##############  BASS  #########################

live_loop :pulsar do
  use_synth :growl
  autosync(:pulse)
  autostop(rrand 3.5, 5) # (rrand_i 5, 8)
  puts "Pulsar"

  # cut = [55, 60, 65, 70, 75, 80, 85, 80, 75, 70, 65, 60].ring.tick(:cut)
  #notes = (knit :c3, 4, :ds3, 1, :b2, 1)
  #notes = (knit :c3, 2, :ds3, 1, :c3, 2, :b2, 1)
  notes = (knit :c3, 2, :ds3, 1, :c3, 1)
  with_fx :reverb, mix: 0.3, room: 0.3, amp: 1 do
    notes.size.times do
      cut = [55, 60, 65, 70, 75, 80, 85, 80, 75, 70, 65, 60].ring.tick(:cut)
      play notes.tick, amp: 0.19, attack: 1.125, sustain: 1.25, release: 3, cutoff: cut, res: 0.2
      sleep 8
    end
  end
  cue :trans
  if one_in 3
    sleep [8, 16, 24].choose
  end
end

############## TUNED RESONATED DRONE  #########################
cue :drn

live_loop :drone do
  autosync(:drn)
  autostop(5) #(rrand_i 6, 8)

  scl = scale(:c5, :harmonic_minor, num_octaves: 1)[0..4]
  # scl = chord([:c1, :c2, :c3].choose, :minor, num_octaves: 2)
  notes = mk_rand_scale(scl, 4)

  puts "Drone sequence: #{notes}"
  (notes.size * 2).times do
    frq = midi_to_hz(notes.tick)
    del = (1.0 / frq)# * 2
    with_fx :echo, amp: 1, mix: 1, phase: del, decay: 2 do
      sample :ambi_drone, attack: 0.6, pan: 0, amp: 0.8, rate: 0.5, cutoff: 117.5
      sleep 8
    end
    cue :prb
  end
end

##############  TUNED RESONATED HUM  #########################

live_loop :probe do
  autosync(:prb)
  autostop(rrand 3.5, 5)
  #notes = chord([:c1, :c2, :c3].choose, :minor, num_octaves: 2).shuffle
  #notes = scale(:c4, :harmonic_minor, num_octaves: 1).shuffle
  notes = (ring 60, 62, 63, 65, 68, 71, 72).shuffle
  puts "Probe sequence: #{notes}"

  vol = 0.8

  4.times do

    with_fx :reverb, mix: [0.5, 0.6, 0.7, 0.8].choose, room: [0.6, 0.7, 0.8].choose do
      with_fx :compressor, threshold:  0.4 do
        with_fx :lpf, res: 0.1, cutoff: [70, 75, 80, 85].choose do
          phase = [0.25, 0.5, 0.75, 1, 1.5, 2].choose
          puts "Probe AM: #{phase}"
          with_fx :slicer, mix: [1, 0.75, 0.5, 0.25].choose, smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do

            frq = midi_to_hz(notes.tick)
            with_fx :echo, amp: 0.7, mix: 0.85, phase: 1.0 / frq, decay: 2 do
              sample :ambi_haunted_hum, beat_stretch: 4, pan: -0.75, amp: vol, rate: (ring -0.25, 0.5, 0.25).tick(:ambi)
            end
            sleep [16, 8, 16].ring.look(:ambi)

            frq = midi_to_hz(notes.tick)
            with_fx :echo, amp: 0.7, mix: 0.85, phase: 1.0 / frq, decay: 2 do
              sample :ambi_haunted_hum, beat_stretch: 4, pan: 0.75, amp: vol, rate: (ring 0.25, -0.5, -0.25).look(:ambi)
            end
            sleep [16, 8, 16].ring.look(:ambi)
          end
          cue :stc
          sleep [4, 6, 8, 12, 16].choose
        end
      end
    end
  end
end

##############  TUNED RINGMOD / SYNTH  #########################

live_loop :transmission do

  autosync(:trans)
  autostop(rrand 4, 5) # (rrand_i 5, 7)
  use_synth :blade
  chd = chord(:c1, :minor, num_octaves: 2).shuffle
  scl = scale([:c4, :c5, :c6].choose, :harmonic_minor, num_octaves: 1)

  notes = mk_rand_scale(scl, 3)
  puts "Transmission sequence: #{notes}"
  slp = [[3,3,2], [4,4,2], [6,6,3], [8,8,4]].choose.ring
  # slp = [[3,3,2], [4,4,2], [2,3,3], [3,2,2]].choose.ring

  (slp.size * 2).times do
    att, sus, rel = slp.tick * 0.3, slp.look * 0.2, slp.look * 0.5
    phase = [0.25, 0.5, 0.75, 1].choose
    mod_frq = rdist(0.0125, 0.5) * midi_to_hz(chd.tick(:chd))
    puts "Transmission AM: #{phase} | Ring mod frq: #{mod_frq}"
    with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
      with_fx :ring_mod, freq: mod_frq do
        with_fx :slicer, mix: [0.9, 0.5, 0.25, 0.125].choose, smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
          play notes.look, amp: 0.07, attack: att, sustain: sus, release: rel, cutoff: 85
          sleep slp.look
        end
      end
    end
  end
  sleep [4, 8, 12, 16, 20].choose
end

live_loop :static do
  autosync(:stc)
  autostop(rrand 3.5, 5)
  puts "Static"
  with_fx :reverb, mix: 0.5, room: 0.5 do
    with_fx :bitcrusher, bits: [12, 14].choose, sample_rate: [4000, 8000, 12000].choose do
      phase = [0.5, 0.25, 0.75, 1].ring
      2.times do
        with_fx :slicer, smooth_up: 0.125, mix: 0.75, phase: phase.tick do
          puts "Static AM: #{phase.look}"
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.15, rate: (ring -1, -2, -0.5).look
          sleep [8, 4, 16].ring.look
          sample :ambi_lunar_land, cutoff: 110, beat_stretch: 8, amp: 0.15, rate: (ring 1, 2, 0.5).look
          sleep 16
        end
        cue :pulse
        sleep [10, 16, 20].choose
      end
    end
  end
end
