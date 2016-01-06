# use_synth :hollow

# live_loop :ambidark do |idx|
#   # test = (chord_degree idx+1, :A3, :hungarian_minor, 3)
#   test = (chord_degree [:i, :iii, :vi, :vii].choose, :A3, :hungarian_minor, 3)

#   puts test
#   play test, attack: 3,release: 3
#   sleep 4
# end


define :ambi_seq do |chord_arr,len=8|
  a = 0.5
  play chord_arr[0], amp: a*rrand(0.8, 1.2), attack: len*rrand(0.5, 0.8), release: len*rrand(0.5, 0.8), cutoff: rrand(75,130)
  play chord_arr[1], amp: a*rrand(0.8, 1.2), attack: len*rrand(0.4, 0.7), release: len*rrand(0.4, 0.7), cutoff: rrand(75,130)
  play chord_arr[2], amp: a*rrand(0.8, 1.2), attack: len*rrand(0.3, 0.6), release: len*rrand(0.3, 0.6), cutoff: rrand(75,130)

end


live_loop :ambipad do
  use_synth :hollow
  len = [4,6,8,12,16].choose
  chords1 = (chord_degree [:i, :vi, :iii, :vii].ring.tick, :A2, :hungarian_minor, 3)
  chords2 = (chord_degree [:i, :vi, :iii, :vii].ring.look, :A3, :hungarian_minor, 3)

  with_fx :reverb, mix: 0.7 do
    4.times do
      ambi_seq(chords1, len)
      ambi_seq(chords2, len)
      sleep len
    end
  end
end



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
  chd = (chord_degree [:i, :iii, :vi, :vii].choose, :A1, :hungarian_minor, 4)

  notes = scales_arr.choose

  puts "Transmission sequence: #{notes}"
  slp = [[3,3,2], [4,4,2], [6,6,3], [8,8,4]].choose.ring
  # slp = [[3,3,2], [4,4,2], [2,3,3], [3,2,2]].choose.ring

  (slp.size * 2).times do
    att, sus, rel = slp.tick * 0.3, slp.look * 0.2, slp.look * 0.5
    phase = [0.25, 0.5, 0.75, 1].choose
    mod_frq = rdist(0.0125, 0.5) * midi_to_hz(chd.tick(:chd))
    puts "Transmission AM: #{phase} | Ring mod frq: #{mod_frq}"
    with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
      with_fx :ring_mod, mix: 0.1, freq: mod_frq do
        with_fx :slicer, mix: rrand(0.2, 0.7), smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
          play notes.look, amp: 0.3, attack: att, sustain: sus, release: rel, cutoff: 85
          sleep slp.look
        end
      end
    end
  end
  # sleep [4, 8, 12, 16, 20, 32].choose
end

live_loop :throb do
  use_synth :prophet
  notes = (degree [:i, :vi, :iii, :vii].ring.tick, :A1, :hungarian_minor)
  with_fx :slicer, phase: 0.5, mix: 0.5, smooth_up: 0.125 do
    play notes, amp: 0.07, release: 8, cutoff: 80
    sleep 8
  end
end
