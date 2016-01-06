# use_synth :hollow

# live_loop :ambidark do |idx|
#   # test = (chord_degree idx+1, :A3, :hungarian_minor, 3)
#   test = (chord_degree [:i, :iii, :vi, :vii].choose, :A3, :hungarian_minor, 3)

#   puts test
#   play test, attack: 3,release: 3
#   sleep 4
# end


define :ambi_seq do |chord_arr, vol, len=8|

  play chord_arr[0], amp: vol*rrand(0.8, 1.2), attack: len*rrand(0.5, 0.8), sustain: len*rrand(0.25, 0.5), release: len*rrand(0.5, 0.8), cutoff: rrand(75,130)
  play chord_arr[1], amp: vol*rrand(0.8, 1.2), attack: len*rrand(0.4, 0.7), sustain: len*rrand(0.25, 0.5), release: len*rrand(0.4, 0.7), cutoff: rrand(75,130)
  play chord_arr[2], amp: vol*rrand(0.8, 1.2), attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.5), release: len*rrand(0.3, 0.6), cutoff: rrand(75,130)
end

live_loop :ambipad do
  use_synth :hollow
  len = [16, 8, 8, 16, 8, 8].ring.look
  # chords1 = (chord_degree [:i, :vi, :iii, :vii].ring.tick, :A2, :hungarian_minor, 3)
  # chords2 = (chord_degree [:i, :vi, :iii, :vii].ring.look, :A3, :hungarian_minor, 3)
  # chords1 = (chord_degree [[:i, :viii].ring.look, :i, :vii, :i, :iii, :vii].ring.tick, :A2, :hungarian_minor, 3)
  chords2 = (chord_degree [:i, :i, :vii, :i, :iii, :vii].ring.tick, :A3, :hungarian_minor, 3)

  with_fx :reverb, mix: 0.7 do
    ambi_seq(chords2, 0.4, len)
    # ambi_seq(chords2, len)
    sleep len
  end
end



scales_arr = []
2.times do
  scl = scale([:a4, :a5].choose, :hungarian_minor, num_octaves: 2)
  scales_arr << mk_rand_scale(scl, 3)
end
puts scales_arr



live_loop :whisper do
  use_synth :dark_ambience

  # autosync(:trans)
  # autostop(rrand max_t*0.8, max_t) # (rrand_i 5, 7)

  notes = scales_arr.choose

  puts "Transmission sequence: #{notes}"
  slp = [[3,3,2], [4,4,2], [6,6,3], [8,8,4]].choose.ring
  # slp = [[3,3,2], [4,4,2], [2,3,3], [3,2,2]].choose.ring

  (slp.size * 2).times do
    att, sus, rel = slp.tick * 0.1, slp.look * 0.3, slp.look * 0.6
    phase = [0.25, 0.5, 0.75, 1].choose
    puts "Whisper Amp Mod: #{phase}}"
    with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
      with_fx :slicer, mix: rrand(0.2, 0.5), smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
        play notes.look, amp: 0.35, attack: att, sustain: sus, release: rel, cutoff: 85
        sleep slp.look
      end
    end
  end
  sleep [4, 8, 12].choose
end

live_loop :throb do
  use_synth :prophet
  notes = (degree [[:i, :viii].ring.look, :i, :vii, :i, :iii, :vii].ring.tick, :A1, :hungarian_minor)
  slp = [4,2,2].ring.look
  puts slp
  with_fx :slicer, phase: 0.5, mix: 0.5, smooth_up: 0.125 do
    play notes, amp: 0.125, release: slp+2, cutoff: 80
    sleep slp
  end
end
