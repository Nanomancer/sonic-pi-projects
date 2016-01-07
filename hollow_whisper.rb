## Hollow Whisper - Coded by Nanomancer
set_volume! 5
use_random_seed Time.now.usec

############ DEFINE FUNCTIONS #################

define :varichord do |chord_arr, vol, len=8|

  play chord_arr[0], amp: vol*rrand(0.8, 1.2),
    attack: len*rrand(0.5, 0.8), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.5, 0.8), cutoff: rrand(75,110), pan: -0.5
  play chord_arr[1], amp: vol*rrand(0.8, 1.2),
    attack: len*rrand(0.4, 0.7), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.4, 0.7), cutoff: rrand(75,110)
  play chord_arr[2], amp: vol*rrand(0.8, 1.2),
    attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.3, 0.6), cutoff: rrand(75,110), pan: 0.5
  # play chord_arr[3], amp: vol*rrand(0.8, 1.2),
  #   attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.5),
  #   release: len*rrand(0.3, 0.6), cutoff: rrand(75,110), pan: 0.5

end

define :mk_rand_scale do |scale, len = 8|
  rand_s = []
  len.times do
    rand_s << scale.choose
  end
  return rand_s.ring
end


#############  PAD  ###############

live_loop :ambipad do
  # map = sync :a_pad
  use_synth :hollow
  tick_reset

  3.times do
    len = [8, 8, 16].ring.tick
    # len = map[:slp]#[6, 2, 4, 2, 2].ring.look
    # chords2 = (chord_invert (chord_degree [:i, :vii, :i, :iii, :vii].ring.tick,
    #                          :A2, :hungarian_minor, 3), rrand_i(0,3))
    # chords2 = (chord_invert (chord_degree [:i, :v, :i, :vii ].ring.tick,
    chords2 = (chord_invert (chord_degree [:i, [:vii, :v].choose, :i].ring.look,

                             :A2, :hungarian_minor, 3), rrand_i(0,3))
    puts "Chord: #{chords2} | length: #{len}"

    # if map[:multi] == 1 then len = [6, 2, 4, 2, 2].ring.look
    # elsif map[:multi] == 0.5 then len = [6, 2, 4, 2, 2].ring.look * 0.5
    # elsif map[:multi] == 2 then len = [6, 2].ring.look
    #   chords2 = (chord_invert (chord_degree [:i, :vii].ring.tick,
    #                            :A2, :hungarian_minor, 3), rrand_i(0,3))
    # end
    # chords2 = (chord_invert (chord_degree [:i, :i, :vii, :i, :iii, :vii].ring.tick,
    # :A2, :hungarian_minor, 3), rrand_i(0,3))

    with_fx :reverb, mix: 0.6 do
      varichord(chords2, 0.35, len)
      sleep len
    end
  end
  if one_in 3 then sleep [8,16,32].choose end
end


############ GENERATE WHISPER SEQUENCE  ##############

scales_arr = []
2.times do
  scl = scale([:a3, :a4].choose, :hungarian_minor, num_octaves: 2)
  scales_arr << mk_rand_scale(scl, 4)
end
puts scales_arr


############### WHISPER LEAD ##################

live_loop :whisper do

  use_synth :dark_ambience
  # autosync(:trans)
  # autostop(rrand max_t*0.8, max_t) # (rrand_i 5, 7)

  notes = scales_arr.choose
  tick_reset
  slp = [[2,1,1,4], [2,2,4], [4,4,8], [4,4]].choose.ring

  (slp.size * 2).times do
    att, sus, rel = slp.tick * 0.1, slp.look * 0.3, slp.look * 0.6
    phase = [0.25, 0.5, 0.75, 1].choose
    with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
      with_fx :slicer, mix: rrand(0.2, 0.5), smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
        play notes.look, amp: 0.4, attack: att, sustain: sus, release: rel, cutoff: 85 # unless one_in(3)
        sleep slp.look
      end
    end
  end
  if one_in(3) then sleep [8, 16, 32].choose end
end


####################################################

################  DARKHARP HIT ################

live_loop :darkharp do

  sync :d_harp
  use_synth :zawa

  # chords2 = (chord_degree [:i, :i, :vii, :i, :iii, :vii].ring.tick,
  chords2 = (chord_degree [:i, :i, :vii, :i, :iii, :vii].ring.tick,

             :A3, :hungarian_minor, 2)

  with_fx :echo, mix: 0.4, phase: 1.5, decay: 10 do
    with_fx :reverb, mix: 0.8, room: 0.6, amp: 0.25 do
      chords2.size.times do
        play chords2.tick(:chrd)+[12, -12].choose, amp: 0.09, attack: 0.0625, release: 1.25, cutoff: 97
        sleep 0.25
        play chords2.tick(:chrd), amp: 0.09, attack: 0.0625, release: 1.5, cutoff: 97
        sleep 0.25
      end
    end
  end
end


############### BASS THROB ################

live_loop :throb do

  use_synth :prophet
  if one_in 5 then multi = 2
  elsif one_in 2 then multi = 0.5
  else multi = 1 end
  # multi = 0.5
  rst, rst_harp = one_in(4), one_in(4)


  cue :a_pad, multi: multi

  12.times do
    notes = (degree [[:i, :viii].ring.look, :i, :vii, :i, :iii, :vii].ring.tick, :A1, :hungarian_minor)
    slp = [4,2,2].ring.look
    slp = slp*multi
    with_fx :slicer, phase: 0.5, mix: 0.5, smooth_up: 0.125 do
      play notes, amp: 0.13, release: slp+2, cutoff: 80 unless rst == true
      sleep slp*0.5
      if multi == 2 && one_in(3) && rst_harp == false then cue :d_harp
      elsif multi == 1 && one_in(8) && rst_harp == false then cue :d_harp end
      sleep slp*0.5
    end
  end
end


###############  DRUMS 1  ################

live_loop :doombeat do
  if one_in(2) then sleep [16, 32, 64].choose end
  16.times do
    sample :loop_industrial, beat_stretch: 2, amp: 0.225, cutoff: 75
    sleep 2
  end
end

###
