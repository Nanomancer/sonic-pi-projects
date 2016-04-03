## Working(ish) title - As The Epoch Ends / falls?
## An experiment in sending values between live_loops to increase 'intelligence' of generative abilities:
## eg loops that can change speed/key depending on another
## Coded by Nanomancer

use_debug false # kills the spam to the log window :)
use_cue_logging false

set_volume! 5
rseed = 236249
# rseed = Time.now.usec # uses the value of the microseconds part of your computers clock as a seed
use_random_seed rseed

File.open('Sync/sonic_pi/epoch_fall.txt', 'a+') do |f|
  ## open or create a txt file and append the value of rseed to it. Doesn't affect SP's output
  ## just for dev/debugging really, useful to capture the results of
  ## a particular clock seed if it does a good run!
  ## put in your own path if you wish to use it, comment out otherwise.
  f.puts("Seed: #{rseed}")
end

# 236249
puts "Seed: #{rseed}"


############ DEFINE FUNCTIONS #################

define :varichord do |chord_arr, vol, len=8|

  # takes an array of MIDI note numbers(preferably some sort of chord) and
  # plays each note with different env/filt settings on each call

  play chord_arr[0], amp: vol*rdist(0.05, 1),
    attack: len*rrand(0.5, 0.8), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.5, 0.8), cutoff: rrand(75,110), pan: -1
  play chord_arr[1], amp: vol*rdist(0.05, 1),
    attack: len*rrand(0.4, 0.7), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.4, 0.7), cutoff: rrand(75,110)
  play chord_arr[2], amp: vol*rdist(0.05, 1),
    attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.6),
    release: len*rrand(0.3, 0.6), cutoff: rrand(75,110), pan: 1
  # play chord_arr[3], amp: vol*rrand(0.8, 1.2),
  #   attack: len*rrand(0.3, 0.6), sustain: len*rrand(0.25, 0.5),
  #   release: len*rrand(0.3, 0.6), cutoff: rrand(75,110), pan: 0.5

end

define :mk_rand_scale do |scale, len = 8|
  # takes a scale array as input and generates a randomised ring array that
  # may have the same note multiple times, default length 8
  rand_s = [] # initialises an empty array
  len.times do
    rand_s << scale.choose ## the 'double less-than' (<<) appends the value of scale.choose to the array
  end
  return rand_s.ring # making it a ring here means less work elsewhere!
end


define :bass_patt do |rst, no_rest, rst_harp, deg, multi, slp|

  ## Gets called twice in the bass throb loop, avoids duplicating code
  ## needs some tidying, posssibly too many arguments(inputs to the function)
  ## variable names are confusing - edit

  play (degree deg, :A1, :hungarian_minor), # degree is an SP builtin, see help
    amp: 0.13, attack: rdist(0.01, 0.02),
    release: slp.tick(:slp)*multi*1.25*rdist(0.1, 1),
    cutoff: rdist(2.1, 80) unless rst # no sound if rst=TRUE
  puts "Bass degree: #{deg}" # used for dev/debug

  sleep slp.look(:slp) *0.5*multi # sleep even if bass is resting, waits for half of the length of a bass note before darkharp gets cued
  unless no_rest && multi == 2 # this block only executes if both values are false
    if multi == 2 && one_in(2) && rst_harp == false then cue :d_harp, degree: deg, multi: multi # 'transmits' the cue msg, note/degree of scale and relative speed
    elsif multi == 1 && one_in(3) && rst_harp == false then cue :d_harp, degree: deg #
    end
  else cue :d_harp, degree: deg # must be for emergency?
  end
  sleep slp.look(:slp) *0.5*multi # cueing complete, the other half of the sleep
end


#############  PAD  ###############

live_loop :ambipad do
  # map = sync :a_pad
  use_synth :hollow
  tick_reset

  3.times do
    len = [8, 8, 16].ring.tick
    chords2 = (chord_invert (chord_degree [:i, [:vii, :v].choose, :i].ring.look,
                             :A2, :hungarian_minor, 3), rrand_i(0,3))
    # puts "Ambipad: #{chords2} | length: #{len}"

    with_fx :reverb, mix: 0.6 do
      varichord(chords2, 0.35, len)
      sleep len
    end
  end
  if one_in 3 then sleep [8,16,32].choose end
end


############ GENERATE WHISPER SEQUENCE  ##############

## uses the mk_rand_scale function to generate two different scale patterns
## this is outside the live loop so only regenerates on run, not each iteration of the whisper loop

scales_arr = []
2.times do # increasing the number of loops here will give more melodic patterns for the whisper live_loop below to choose from
  scl = scale(:a3, :hungarian_minor, num_octaves: 2)
  scales_arr << mk_rand_scale(scl, 3)
end
puts "Generated patterns for whisper loop:\n#{scales_arr}" # just checking, puts is your friend and will make debugging so much easier :)


############### WHISPER LEAD ##################

live_loop :whisper do

  use_synth :dark_ambience
  # autosync(:trans)
  # autostop(rrand max_t*0.8, max_t) # (rrand_i 5, 7)

  notes = scales_arr.choose # remember our array - 'scales_arr' is multidimensional - it's lists within a list, so this
  slp = [[2,2,4], [2,2], [4,4,8], [4,4], [2,1.5,0.5,4]].choose.ring

  2.times do
    tick_reset
    slp.size.times do
      att, sus, rel = slp.tick * 0.1, slp.look * 0.4, slp.look * 0.6
      phase = [0.25, 0.5, 0.75, 1].choose
      with_fx :echo, mix: 0.25, phase: 1.5, decay: 4 do
        with_fx :slicer, mix: rrand(0.2, 0.5), smooth_up: phase * 0.5, smooth_down: phase * 0.125, phase: phase do
          play notes.look, amp: 0.4, attack: att, sustain: sus, release: rel, cutoff: 85 # unless one_in(3)
          sleep slp.look
        end
      end
    end
    sleep 8
  end
  if one_in(3) then sleep [8, 16, 32].choose end
end


####################################################

################  DARKHARP HIT ################

live_loop :darkharp, auto_cue: false do

  map = sync :d_harp
  use_synth :zawa

  chords2 = (chord_degree map[:degree], :A3, :hungarian_minor, 5)
  puts "Darkharp degree: #{map[:degree]}"

  if map[:multi] == 2 then slp = [0.25,0.5,0.75].choose
  else slp = 0.25
  end
  # slp = 0.75
  note1 = [0, 1].choose
  if one_in(3) then reps = 1
  else reps = 2
  end
  ## explain this block. seek help on pattern/rule to enable simplification mathmetically?
  ##
  if map[:degree] == :i || map[:degree] == :viii && note1 == 0 then note2 = note1 + [1,2,3,4].choose
  elsif map[:degree] == :i || map[:degree] == :viii && note1 == 1 then note2 = note1 + [1,3,4].choose
  elsif map[:degree] == :iii && note1 == 0 then note2 = note1 + [1,3].choose
  elsif map[:degree] == :iii && note1 == 1 then note2 = note1 + [1,2,4].choose

  elsif map[:degree] == :vii && note1 == 0 then note2 = note1 + [1,4].choose
  elsif map[:degree] == :vii && note1 == 1 then note2 = note1 + [3,4].choose
  end
  with_fx :echo, mix: 0.4, phase: 1.5, decay: 10 do
    with_fx :reverb, mix: 0.7, room: 0.6, amp: 0.5 do
      reps.times do

        oct = [12, -12].choose
        puts "Darkharp notes- N1= #{note1+1} - N2= #{note2+1}"
        play chords2[note1]+oct, amp: 0.1, attack: rdist(0.01, 0.06), release: rdist(0.125, 1.25), cutoff: rdist(3, 95), pan: 1
        sleep slp
        play chords2[note2], amp: 0.1, attack: rdist(0.01, 0.07), release: rdist(0.1, 1.5), cutoff: rdist(3, 95), pan: -1
        sleep slp
      end
    end
  end
end


############### BASS THROB ################

live_loop :throb do

  ## the heart of it all, generates the bassline and lets ambipad and darkharp know what to play
  use_synth :prophet
  # set relative speed of bassline
  if one_in 4 then multi = 2
  elsif one_in 2 then multi = 0.5
  else multi = 1
  end
  # multi = 2
  rst, rst_harp, no_rest = one_in(4), one_in(8), one_in(6) # lets get these variable names a little more clear!
  slp = [4,2,2].ring

  cue :a_pad, multi: multi # lets ambipad know what's going on :)
  deg1_reps = [3,9].choose

  with_fx :slicer, phase: 0.5, mix: 0.5, smooth_up: 0.125 do
    2.times do
      deg1_reps.times do

        deg1 = [[:i, :viii].ring.tick(:oct), :i, :vii].ring.tick # yeah, I'm confused too. Alternates octaves...
        bass_patt(rst, no_rest, rst_harp, deg1, multi, slp) #
      end

      3.times do
        deg2 = [:i, :iii, :vii].ring.tick
        bass_patt(rst, no_rest, rst_harp, deg2, multi, slp)
      end
    end
  end
end

###############  DRUMS 1  ################

live_loop :doombeat do
  if one_in(3) then sleep [16, 32, 64].choose end #

  if one_in(2)
    puts "Doombeat 1" # using your own debugging makes it clear what part of the loop is executing(or not) at any given time
    cut = rrand(65, 80)
    16.times do
      sample :loop_industrial, beat_stretch: 2, amp: 0.225, cutoff: cut
      sleep 2
    end

  elsif one_in(3)
    puts "Doombeat 2"
    16.times do
      sample :loop_industrial, beat_stretch: 2, amp: 0.225, cutoff: range(60, 85, step: 2.5).mirror.ring.tick
      sleep 2
    end

  else
    puts "Doombeat 3"
    cut = rrand(70, 80)
    8.times do
      sample :loop_industrial, beat_stretch: 4, amp: 0.25, cutoff: cut
      sleep 4
    end
  end
end

###
