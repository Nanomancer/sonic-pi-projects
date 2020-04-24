# Sonic Pi Euclidean Drum Machine
use_bpm 120
set_volume! 4
editQuantisation = 2 # bars to quantise code edits to

"" " Hat Settings " ""
hatRate = 2 # 1 = every 1/16, 2 = every 1/8 etc...
numberOfOpenHats = 1  #3  #2  #2  #3  #2 #3
hatPatternLength = 8 #11 #11 #10 #10 #5 #8
hatOffset = 2
##| hatRotate = hatOffset - 1
hatRotate = 2
offbeat = false
##| offbeat = true
muteHat = false
##| muteHat = true

"" " Kick & Snare Settings " ""
numberOfKicks = 2
kickPatternLength = 8
kickRotate = 3
muteKick = false
##| muteKick = true

numberOfSnares = 2
snarePatternLength = 16
snareRotate = 2
snareOffset = 3
muteSnare = false
##| muteSnare = true

"" " Master Clock " ""
rate = 1 # speed, increase slows
clockReset = 2 # bars to reset clocks at

##| dynamicsArray = [0.9, 0.45, 0.66, 0.5, 0.85, 0.4, 0.7, 0.4].ring
dynamicsArray = [1, 0.7, 0.85, 0.65, 0.95, 0.75, 0.9, 0.65].ring

###### Rhythm patterns ######
hatPattern = spread(numberOfOpenHats, hatPatternLength, rotate: hatRotate)
kickPattern = spread(numberOfKicks, kickPatternLength, rotate: kickRotate)
snarePattern = spread(numberOfSnares, snarePatternLength, rotate: snareRotate)
### Randomisation settings - dynamics & hat envs ###
randAmt = 0.05
randHigh = 1 + randAmt
randLow = 1 - randAmt
timingAmt = 0.000025

live_loop :eucliDrum do
  (editQuantisation * 16).times do

    ### RESET / CRASH ###
    if look % (clockReset * 16) == 0 && look != 1
      tick_set(1)
      tick_reset(:hat)
      tick(:hat)
      puts "hat trig in master reset, look:hat= #{look(:hat)}"
      tick_reset(:snare)
      tick(:snare)
      tick_reset(:kick)
      puts "resetting all ticks"
      ##| sample :glitch_perc4, rate: 1.75, amp: 0.4 * dynamicsArray.tick(:hit) * rrand(randLow, randHigh)
    end
    tick

    ### KICK ###
    if !muteKick
      if kickPattern.look(offset: -1)
        if (tick(:kick) % (numberOfKicks * 2) == 0 && look(:kick) != 0) ||
           (look(:kick) >= numberOfKicks && numberOfKicks % 2 != 0) ||
           (look(:kick) >= numberOfKicks && kickPatternLength % 2 != 0)
          tick_reset(:kick)
          puts "resetting kick tick"
          tick(:kick)
        end
        aDynamic = dynamicsArray.look(:kick)
        playKick(aDynamic)
      end
    end

    ### SNARE ###
    if !muteSnare
      if snarePattern[tick(:snare) + snareOffset]
        ##| puts "snare"
        with_fx :distortion, amp: 0.2,
                             distort: 0.75 * rrand(randLow, randHigh), mix: 0.8 * rrand(randLow, randHigh) do
          sample :drum_snare_hard,
            cutoff: 130 * rrand(0.92, 1.00) * ((0.2 * dynamicsArray.look(offset: -1)) + 0.8),
            rate: 1 * rrand(0.991, 1.009) * ((0.08 * dynamicsArray.look(offset: -1)) + 0.92),
            attack: 0.0025 * rrand(0.9, 1.1),
            amp: 0.25 * dynamicsArray.look(offset: -1) * rrand(0.9, 1.1)
        end
      end
    end

    ### HAT ###
    if !muteHat
      if offbeat
        lookOffset = 1
        hatRate = 4
      else
        lookOffset = -1
      end
      if look(offset: lookOffset) % hatRate == 0
        puts "hat trig, look:hat= #{look(:hat)}"
        tick(:hat)
        puts "hat ticked, new look = #{look(:hat)}"
        if hatPattern[look(:hat) + hatOffset]
          puts "Open Hat"
          sample :drum_cymbal_open,
            cutoff: 130 * rrand(0.995, 1.00) * ((0.2 * dynamicsArray.look(:hat)) + 0.8),
            rate: 1 * rrand(0.995, 1.005) * ((0.03 * dynamicsArray.look(:hat)) + 0.97),
            attack: 0.0025 * rrand(0.9, 1.1),
            finish: hatRate * 0.085 * rrand(randLow, randHigh),
            release: hatRate * 0.25 * rrand(randLow, randHigh),
            amp: 0.4 * dynamicsArray.look(:hat) * rrand(0.9, 1)
        else
          sample :drum_cymbal_closed,
            cutoff: 130 * rrand(0.995, 1.00) * ((0.2 * dynamicsArray.look(:hat)) + 0.8),
            rate: 1 * rrand(0.995, 1.005) * ((0.04 * dynamicsArray.look(:hat)) + 0.96),
            attack: 0.0025 * rrand(0.9, 1.1),
            attack: 0.005 * rrand(randLow, randHigh),
            finish: rrand(0.75, 1),
            release: rrand(0.01, 0.05),
            amp: 0.45 * dynamicsArray.look(:hat) * rrand(0.8, 1.2)
        end
      end
    end
    sleep (rate * 0.25) + rrand(-timingAmt, timingAmt)
  end
end

### TO DO ###

# set clock to 24 ppq
