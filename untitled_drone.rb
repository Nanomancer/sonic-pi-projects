## Untitled Drone - Coded by Nanomancer
ndefine :darkrun do |interval, slp|
  play notes[map[:prog]+interval]
  sleep slp*0.25
end

live_loop :dronetest do
  use_synth :zawa

  seq = [[5, 3, 5, 1], [7, 3, 1, 2]].ring.tick(:seq)
  slp = 4 # [4, 8].choose
  vol = 0.5
  8.times do
    prog = seq.ring.tick
    cue :drn, prog: prog-1
    puts "prog: #{prog}"
    chord_arr = chord_degree(prog, :e1, :minor, 3)
    with_fx :reverb do
      in_thread do
        2.times do
          play chord_arr[1]+24, attack: slp*0.125, sustain: slp*0.375, cutoff: 68, res: 0.5, phase: slp*0.25, range: 24, wave: 2, amp: vol*0.5
          sleep slp*0.5
        end
      end
      play chord_arr[0], attack: slp*0.125, sustain: slp*0.875, cutoff: 62, res: 0.5, phase: slp*0.5, range: 24, wave: 2, amp: vol
      play chord_arr[2]+12, attack: slp*0.125, sustain: slp*0.875, cutoff: 65, res: 0.5, phase: slp, range: 24, wave: 2, amp: vol*0.5
      sleep slp
    end
  end
end


live_loop :dronetest1 do
  map = sync :drn
  notes = scale(:e4, :minor_pentatonic, num_octaves: 2)
  use_synth :dark_ambience
  with_fx :reverb do
    play notes[map[:prog]+4]
    sleep 1
    play notes[map[:prog]+3]
    sleep 1
    play notes[map[:prog]+2]
    sleep 1
    play notes[map[:prog]]
    sleep 1

  end
end

# live_loop :dronetest2 do
#   use_synth :zawa
#   with_fx :reverb do
#     sleep 16
#   end
# end

# live_loop :ambirub do
#   sample :ambi_glass_rub, rate: 1, amp: 0.35, attack: 1
#   sleep 16
# end

# live_loop :gut do
#   sleep 4
#   sample :guit_e_fifths, amp: 0.3
#   sleep 4
# end
