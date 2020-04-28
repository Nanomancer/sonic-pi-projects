
define :avalanche do
  editQuantisation = get[:editQuantisation] * 16
  
  
  editQuantisation.times do
    
    ### RESET / CRASH ###
    if look % (patternLength * 16) == 0 && look != 1
      puts "resetting all ticks"
      tick_reset_all
      tick_set(1)
      hatCount = tick(:hat)
      snareCount = tick(:snare)
      puts "hatCount: #{hatCount}, snareCount: #{snareCount}, masterClock: #{look}"
    end
    
    masterClock = tick
    
    
    ### KICK ###
    if ! get[:muteKick]
      if get[:kickPattern][ masterClock - 1 ]
        
        ##| if (kickCount % (numberOfKicks * 2) == 0 && kickCount != 0) ||
        ##|     (kickCount >= numberOfKicks && numberOfKicks % 2 != 0) ||
        ##|     (kickCount >= numberOfKicks && kickPatternLength % 2 != 0)
        ##|   tick_reset(:kick)
        ##|   puts "resetting kick count"
        ##|   kickCount = tick(:kick)
        ##| end
        
        kickCount = tick(:kick)
        kickDynamic = get[:dynamicPattern][kickCount]
        playKick(kickDynamic)
        puts "Kick"
      end
    end
    
    ##| ### SNARE ###
    ##| if !muteSnare
    ##|   snareCount = tick(:snare)
    ##|   if snarePattern[ snareCount + snareOffset ]
    ##|     puts "snare"
    ##|     snareDynamic = dynamicsArray[snareCount]
    ##|     playSnare(snareDynamic)
    ##|   end
    ##| end
    
    ##| ### HAT ###
    ##| if !muteHat
    
    ##|   if get[:offbeat]
    ##|     lookOffset = 1
    ##|     hatRate = 4
    ##|   else
    ##|     lookOffset = -1
    ##|   end
    ##|   hatRate = get[:hatRate]
    ##|   if (masterClock + lookOffset) % hatRate == 0
    ##|     hatCount = tick(:hat)
    ##|     ##| puts "hatCount: #{hatCount}"
    ##|     if hatPattern[ hatCount + hatOffset ]
    ##|       puts "Open Hat"
    ##|       sample :drum_cymbal_open,
    ##|         cutoff: 130 * rrand(0.995, 1.00) * ((0.2 * dynamicsArray.look(:hat)) + 0.8),
    ##|         rate: 1 * rrand(0.995, 1.005) * ((0.03 * dynamicsArray.look(:hat)) + 0.97),
    ##|         attack: 0.0025 * rrand(0.9, 1.1),
    ##|         finish: hatRate * 0.085 * rrand(randLow, randHigh),
    ##|         release: hatRate * 0.25 * rrand(randLow, randHigh),
    ##|         amp: 0.4 * dynamicsArray.look(:hat) * rrand(0.9, 1)
    ##|     else
    ##|       sample :drum_cymbal_closed,
    ##|         cutoff: 130 * rrand(0.995, 1.00) * ((0.2 * dynamicsArray.look(:hat)) + 0.8),
    ##|         rate: 1 * rrand(0.995, 1.005) * ((0.04 * dynamicsArray.look(:hat)) + 0.96),
    ##|         attack: 0.0025 * rrand(0.9, 1.1),
    ##|         attack: 0.005 * rrand(randLow, randHigh),
    ##|         finish: rrand(0.75, 1),
    ##|         release: rrand(0.01, 0.05),
    ##|         amp: 0.45 * dynamicsArray.look(:hat) * rrand(0.8, 1.2)
    ##|     end
    ##|   end
    ##| end
    sleep (rate * 0.25) + rrand(-timingAmt, timingAmt)
  end
end


