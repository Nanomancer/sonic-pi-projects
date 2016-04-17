# list=[0,1,2,3,4,5]
# # idx = 0
# live_loop :test do |b|
#   #   choice = list.choose
#   #   puts"list item #{choice}"
#   puts b
#   #   # rand_back
#   sleep 1
#   # b += 1
# end
set_volume! 5
##| use_random_seed 323831.5012207031
##| puts current_random_seed
##| rand_skip(1)
use_bpm 120
##| sample_free_all

live_loop :safari, delay: 32 do
  with_fx :reverb, mix: 0.4, room: 0.6 do
    if one_in(2)
      sample :loop_safari, amp: 0.9, finish: 0.5, rate: 0.5, beat_stretch: 16
    end
    if one_in(2)
      sample :loop_safari, amp: 0.4, rate: 1, beat_stretch: 16
    end
    ##| sample :loop_compus, start: 0, rate: 1, beat_stretch: 16, amp: 0.7, cutoff: 110
    
    sleep 16
  end
end

seeds = [323707.5012207031,
         323707.5012207031,
         323677.5012207031,
         323701.5012207031,
         323731.5012207031,
         323707.5012207031,
         323737.5012207031,
         323749.5012207031,
         323755.5012207031,
         323761.5012207031,
         323767.5012207031,
         323773.5012207031,
         323779.5012207031,
         323785.5012207031,
         323729.5012207031,
         323729.5012207031,
         324143.5012207031,
         323729.5012207031
         ].ring

seeds = [323699.5012207031, 323705.5012207031, 323723.5012207031, 323729.5012207031, 323735.5012207031, 323747.5012207031, 323759.5012207031, 323771.5012207031, 323831.5012207031, 323837.5012207031, 323861.5012207031, 323867.5012207031, 323897.5012207031, 323993.5012207031, 324017.5012207031].ring
##| autoseeder = []
live_loop :eastern_twang do |idx|
  use_synth :pluck
  ##| if look == 0 then rand_skip(8) end
  with_random_seed seeds[idx] do
    puts "SEED: #{current_random_seed} loop no.: #{idx}"
    ##| autoseeder << current_random_seed
    ##| puts autoseeder
    notes = scale(:a3, :harmonic_minor, num_octaves: dice(2)).pick(4)
    cut = range(50, 130, step: 2.5).mirror.ring
    slp = [1,1.5,0.5,1].ring
    multi = [0.5,1,1.5,2].choose
    if multi == 0.5 || multi == 1 then reps = 16
    else reps = 8 end
    with_fx :echo, mix: 0.4, phase: 2, max_phase: 4 do
      with_fx :reverb, mix: 0.65, room: 0.85 do
        reps.times do
          play notes.tick, amp: 0.3*rdist(0.09, 1), cutoff: rdist(15, 115), pitch: rdist(0.1, 0)
          sleep slp.look*multi
        end
      end
      ##| end
    end
    idx+=1
  end
end

##| live_loop :fauxvox, delay: 8 do
##|   use_synth :saw
##|   notes = scale(:a3, :harmonic_minor, num_octaves: dice(2)).pick(4)
##|   slp = [1,1.5,0.5].ring
##|   multi = [2, 3, 4].choose
##|   with_fx :vowel, vowel_sound: 4, voice: 0 do
##|     with_fx :reverb, mix: 0.75, room: 0.9 do
##|       with_fx :echo, mix: 0.4, phase: 4, max_phase: 4 do
##|         3.times do
##|           play notes.tick, amp: 0.1, cutoff: 125, attack: slp.look*multi*0.4, release: slp.look*multi*0.6
##|           sleep slp.look*multi
##|         end
##|       end
##|     end
##|   end
##| end
##| live_loop :foo do |a|
##|   if one_in(2)
##|     puts "Chance"
##|   end
##|   puts a
##|   with_fx :bitcrusher, amp: 0.7, bits: [4,6,8].choose, sample_rate: [500,750,1000,1250,1500].choose do
##|     ##| with_fx :krush do
##|     sample [:drum_snare_soft, :bd_haus].ring.look
##|     sleep [1,1.5,0.5,1].ring.tick
##|     ##| end
##|   end
##|   a += 5
##| end

##| load_samples "tabla_"

##| live_loop :tabla do
##|   sample "drum_", tick
##|   sleep 0.25
##| end
