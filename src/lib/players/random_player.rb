require 'players/dummy_player'
require 'players/gambler_player'

module Players
  # RandomPlayer randombly creates other players and asks them
  # what they would do and acts according to that.
  class RandomPlayer < DummyPlayer
    def roll(dice)
      player_types = [Players::GamblerPlayer, Players::DummyPlayer]
      player_types[rand(player_types.length)].new.roll(dice)
    end
  end
end