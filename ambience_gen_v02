# Ambience Generator v0.2 coded by J.A Smith

define :sample_rates do
  sample_rates = [0.0625, 0.125, 0.25, 0.3333, 0.5,  0.6666, 0.75, 1, 1.3333, 1.5, 1.6666, 1.75, 2, -0.0625, -0.125, -0.25, -0.3333, -0.5,  -0.6666, -0.75, -1, -1.3333]
end

define :sample_rates2 do
  sample_rates = [0.0625, 0.125, 0.25, 0.5, 0.75, 1, 1.5, 1.75, 2, -0.0625, -0.125, -0.25, -0.5, -0.75, -1, -1.5]
end

define :retrigger_rates do
  retrigger_rates = [0.0625, 0.125, 0.25, 0.5, 0.75, 1, 1.5, 1.75, 2, 4, 6, 8,]
end

define :play_bell do |bell_rate|
  sample :perc_bell, rate: bell_rate, amp: (rrand 0.3, 0.7), attack: (rrand 0.1, 0.5)
end

define :play_glass do |glass_rate|
  sample :ambi_glass_hum, rate: glass_rate, amp: (rrand 0.5, 1)
end

use_random_seed 456 

live_loop :bell do
  
  bell_rate = choose(sample_rates2)
  bell_sleep = choose(retrigger_rates)

   if bell_rate < 0
    with_fx :echo, phase: bell_rate * -1, decay: rrand(2,6) do
      play_bell(bell_rate)
      sleep(bell_sleep)
      end
   else
    play_bell(bell_rate)
    sleep(bell_sleep)
  end

end

live_loop :glass do

  glass_rate = choose(sample_rates)
  glass_sleep = choose(retrigger_rates)

  play_glass(glass_rate)
  sleep(glass_sleep)

end
