# use_synth :hollow

# live_loop :ambidark do |idx|
#   # test = (chord_degree idx+1, :A3, :hungarian_minor, 3)
#   test = (chord_degree [:i, :iii, :vi, :vii].choose, :A3, :hungarian_minor, 3)

#   puts test
#   play test, attack: 3,release: 3
#   sleep 4
# end


define :ambi_seq do |chord_arr, vol, len=8|

  play chord_arr[0], amp: vol*rrand(0.8, 1.2),
    attack: len*rrand(0.5, 0.8), sustain: len*rrand(0.25, 0.5),
    release: len*rrand(0.5, 0.8), cutoff: rrand(75,130), pan: -0.5
  play chord_arr[1], amp: vol*rrand(0.8, 1.2),
    attack: len*rrand(0.4, 0.7), sustain: len*rrand(0.25, 0.5),
    release: len*rrand(0.4, 0.7), cutoff: rrand(75,130)
  play chord_arr[2], amp: vol*rrand(0.8, 1.2),
    attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.5),
    release: len*rrand(0.3, 0.6), cutoff: rrand(75,130), pan: 0.5
end

####################################################


live_loop :ambipad do
  use_synth :hollow
  len = 8#[16, 8, 8, 16, 8, 8].ring.look
  # chords1 = (chord_degree [:i, :vi, :iii, :vii].ring.tick, :A2, :hungarian_minor, 3)
  # chords2 = (chord_degree [:i, :vi, :iii, :vii].ring.look, :A3, :hungarian_minor, 3)
  # chords1 = (chord_degree [[:i, :viii].ring.look, :i, :vii, :i, :iii, :vii].ring.tick, :A2, :hungarian_minor, 3)
  chords2 = (chord_invert (chord_degree [:i, :i, :vii, :i, :iii, :vii].ring.tick,
                           :A3, :hungarian_minor, 3), rrand_i(0,3))

  with_fx :reverb, mix: 0.7 do
    # ambi_seq(chords2, 0.8, len)
    # ambi_seq(chords2, len)
    sleep len
  end
end

####################################################

live_loop :darkharp do
  sync :d_harp
  # use_synth :pretty_bell
  use_synth :zawa

  chords2 = (chord_degree [:i, :i, :vii, :i, :iii, :vii].ring.tick,
             :A3, :hungarian_minor, 2)

  with_fx :echo, mix: 0.4, phase: 1.5, decay: 10 do
    with_fx :reverb, mix: 0.8, room: 0.6, amp: 0.35 do
      chords2.size.times do
        play chords2.tick(:chrd)+[12, -12].choose, amp: 0.09, attack: 0.0625, release: 1.25, cutoff: 97
        sleep 0.25#1.0/3
        play chords2.tick(:chrd), amp: 0.09, attack: 0.0625, release: 1.5, cutoff: 97
        sleep 0.25#1.0/3
      end
    end
  end
end
####################################################

scales_arr = []
2.times do
  scl = scale([:a3, :a4].choose, :hungarian_minor, num_octaves: 2)
  scales_arr << mk_rand_scale(scl, 3)
end
puts scales_arr



live_loop :whisper do
  use_synth :dark_ambience

  # autosync(:trans)
  # autostop(rrand max_t*0.8, max_t) # (rrand_i 5, 7)

  notes = scales_arr.choose

  puts "Transmission sequence: #{notes}"
  slp = [[3,3,2], [4,2,2], [8,4,4], [8,6,2]].choose.ring
  # slp = [[3,3,2], [4,4,2], [2,3,3], [3,2,2]].choose.ring

  (slp.size * 2).times do
    att, sus, rel = slp.tick * 0.1, slp.look * 0.3, slp.look * 0.6
    phase = [0.25, 0.5, 0.75, 1].choose
    puts "Whisper Amp Mod: #{phase}}"
    with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
      with_fx :slicer, mix: rrand(0.2, 0.5), smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
        play notes.look, amp: 0.4, attack: att, sustain: sus, release: rel, cutoff: 85
        sleep slp.look
      end
    end
  end
  sleep [4, 8, 12].choose
end

####################################################



####################################################


live_loop :throb do
  use_synth :prophet

  if one_in 5 then multi = 2
  elsif one_in 2 then multi = 0.5
  else multi = 1 end

  12.times do
    notes = (degree [[:i, :viii].ring.look, :i, :vii, :i, :iii, :vii].ring.tick, :A1, :hungarian_minor)
    slp = [4,2,2].ring.look
    slp = slp*multi
    puts slp
    with_fx :slicer, phase: 0.5, mix: 0.5, smooth_up: 0.125 do
      play notes, amp: 0.125, release: slp+2, cutoff: 80
      sleep slp*0.5
      if multi == 2 && one_in(2)
        cue :d_harp
      end
      sleep slp*0.5
    end
  end
  if one_in 3
    sleep [8,16,32].choose
  end
end

####################################################


live_loop :doombeat do
  sample :loop_industrial, beat_stretch: 2, amp: 0.2, cutoff: 75
  sleep 2
end

###
