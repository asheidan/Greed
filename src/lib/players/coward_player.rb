require 'players/dummy_player'

module Players
  
  # Implements a player which always stays disregarding of which dice
  # are thrown.
	class CowardPlayer < DummyPlayer
		def roll(dice)
			[]
		end	
	end
end
