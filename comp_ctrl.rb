set_volume! 5
use_bpm 120

glitches = "/home/james/A_Sync/Samples/sonic_pi_samples/interference"
nasa = "/home/james/A_Sync/Samples/sonic_pi_samples/Nasa"

live_loop :glitch1 do
  with_fx :echo, phase: 0.75, decay: 2 do
    if spread(3,8).tick(:glt1) then sample glitches, "glitch", 2 end
    sleep 0.75
  end
end

live_loop :glitch2 do
  with_fx :echo, phase: 0.75, decay: 2 do
    if spread(3,8).tick(:glt2) then sample glitches, "glitch", 9 end
    sleep 0.5
  end
end

live_loop :kick do
  sample :drum_bass_soft
  sleep 1
end

live_loop :morse do
  ##| sync :glitch1
  with_fx :reverb, mix: 0.6, room: 0.7 do
    sample nasa, "morse", 1, rpitch: [0, -1].ring.tick, amp: 0.6
    sleep 8
  end
end

live_loop :vger do
  with_fx :slicer, phase: 1.5, offset: 0.75, smooth_up: 0.25 do
    with_fx :slicer, phase_offset: 1, smooth_up: 0.25 do
      
      sample glitches, "loop", 0, beat_stretch: 8, amp: 0.6, rate: [1,-1].ring.tick
      sleep 8
    end
  end
end

##| live_loop :bass do
##|   if spread(3,8).tick(:glt2) then play
