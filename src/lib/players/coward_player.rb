require 'players/dummy_player'

module Players
	class CowardPlayer < DummyPlayer
		def roll(dice)
			[]
		end	
	end
end
