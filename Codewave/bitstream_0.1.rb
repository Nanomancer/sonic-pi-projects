set_volume! 5
epoch_seed = Time.now.usec
puts epoch_seed
use_random_seed epoch_seed #247444#
# use_random_seed 704169
set_sched_ahead_time! 1
# a = 0
# fadeout = false
# # tick_set 0.00
#   # autosync(:drn)
#   if a <= 0.10 && fadeout == false#0.1
#     a += 0.01
#     puts a
#   else# a >= 0.1 && fadeout == true
#     fadeout = true
#     while a > 0
#       a -= 0.01
#       puts a
#     end
#     puts "fadeout"
#     #   tick_reset
#     #   a = tick * -0.01

#   end

live_loop :fourfour do
  if one_in 8
    sleep [8, 16].choose
  else
    8.times do
      sample :bd_haus, amp: 0.3, cutoff: 75, rate: 0.9
      sleep 0.5
    end
  end
end

live_loop :looper do
  if one_in 6
    sleep [8, 16].choose
  else
    len = [1,2].choose
    if one_in 4
      slp = len * 2
    else
      slp = len
    end
    8.times do
      sample :loop_industrial, beat_stretch: len, amp: 0.125
      sleep slp
    end
  end
end

live_loop :looper2 do
  if one_in 6
    sleep [8, 16].choose
  else
    len = [8,16].choose
    if len > 8 && (one_in 4)
      slp = len * 2
    else
      slp = len
    end
    2.times do
      sample :loop_garzul, beat_stretch: len, amp: 0.15
      sleep slp
    end
  end
end

live_loop :offbass do

  notes = [:c2, :ds2, :c2].ring
  use_synth :subpulse
  if one_in 8
    sleep [16, 32].choose
  else
    with_fx :distortion, amp: 0.1, distort: 0.97 do
      notes.size.times do
        tick
        16.times do
          sleep 0.25
          play notes.look, release: 0.4, amp: 0.2, cutoff: 75, res: 0.1
          synth :sine, note: notes.look, amp: 0.1, attack: 0.04, release: 0.4
          sleep 0.25
        end
      end
    end
  end
end



max_t = 3
cue :pulse

live_loop :bitstream do
  # use_synth :growl
  use_synth :dpulse

  autosync(:pulse)
  autostop(rrand max_t*0.65, max_t) # (rrand_i 5, 8)

  # notes = (knit :c2, 2, :ds2, 1, :c2, 1)
  notes = (chord :c2, :minor)

  if one_in 4
    sleep [16,32].choose
  else
    puts "Bitstream"
    with_fx :slicer, phase: [0.25, 0.125].choose, smooth_up: 0.01, smooth_down: 0.01 do
      with_fx :bitcrusher, mix: 0.4, bits: [4, 5, 6].choose, sample_rate: (range 1500, 3000, step: 250, inclusive: true).choose do

        with_fx :reverb, mix: 0.3, room: 0.4, amp: 0.5 do
          # notes.size.times do
          4.times do

            # cut = [55, 60, 65, 70, 75, 80, 85, 80, 75, 70, 65, 60].ring
            cut = (range 50, 110, step: 10, inclusive: true)
            cut2 = (range 110, 50, step: 10, inclusive: true)

            s = play notes.tick, note_slide: 0.5, amp: 0.1, attack: 0.1, sustain: 8, release: 0.1, cutoff: cut.look(:cut), cutoff_slide: 4, res: 0.2
            control s, cutoff: cut2.look(:cut)
            sleep 4
            control s, cutoff: cut.tick(:cut)
            sleep 3.5
            control s, note: notes.tick
            sleep 0.5
          end
        end
      end
    end
  end
end


sprd_arr = [3,4,5,6,7,8].shuffle
scales_arr = []
2.times do
  scl = scale([:c5, :c6].choose, :harmonic_minor, num_octaves: 2)
  scales_arr << mk_rand_scale(scl, 8)
end
puts scales_arr

live_loop :crystal_entity do
  use_synth :dark_ambience

  notes = scales_arr.choose

  sprd1 = sprd_arr[0..2].choose
  rtm_arr = (spread sprd1, 8)
  2.times do
    4.times do
      tick_reset(:rtm)
      tick_reset
      8.times do
        if rtm_arr.tick(:rtm)
          if sprd1 <= 5
            with_fx :echo, mix: 0.4, phase: [0.75, 1.5, 3].choose, decay: 8 do
              play note notes.look(:rtm), amp: 1
            end
          else
            play note notes.look(:rtm), amp: 1
          end
        end
        sleep 0.25#[0.125, 0.25, 0.5].choose
      end
    end
    if one_in 3
      sleep 8
    end
  end
  if one_in 2
    sleep [8, 16].choose
  end
end
