require 'tk'

DIE_VALUE = 0
DIE_BUTTON = 1

module UI
  class ManualWindow
    def initialize
      
      @@name_var = TkVariable.new
      @@scores_var = TkVariable.new
      @@limit_var = TkVariable.new
      
      @@die_vars = Array.new(6) do
        [TkVariable.new, TkVariable.new] # value and button
      end
      
      $state = :sleep
      
      @@saved_dice = Array.new
      
      TkFrame.new(Tk.root) do
        TkLabelFrame.new(self) do
          TkLabel.new(self) do
            textvariable @@name_var
            pack
          end
          @@die_frame = TkFrame.new(self) do
            6.times do |i|
              TkFrame.new(self) do
                TkLabel.new(self) do
                  textvariable @@die_vars[i][DIE_VALUE]
                  pack
                end
                TkCheckButton.new(self) do
                  variable @@die_vars[i][DIE_BUTTON]
                  pack
                end
                pack :side => :left
              end
            end
            pack
          end
          TkButton.new(self) do
            text 'Submit'
            command do
              $state = :done if $state == :wait
            end
            pack
          end
          
          text 'Turn Status'
          pack :fill => :x
        end
        
        TkLabelFrame.new(self) do
          TkScrollbox.new(self) do
            listvariable @@scores_var
            pack
          end
          TkLabel.new(self) do
            textvariable @@limit_var
            pack
          end
          
          text 'Game Status'
          pack :fill => :x
        end
        
        pady 2
        padx 2
        grid :row => 0, :column => 0
      end
    end
    
    def update_scoreboard(scores = {})
      list = []
      pairs = scores.sort_by {|k, v| k}
      pairs.each do |k, v|
        list << "#{k} : #{v}"
      end
      @@scores_var.value = list
    end
    
    def status_update(name, dice, saved=[])
      # TODO: Found a bug http://github.com/asheidan/Greed/issues/#issue/1
      puts saved
      set_current_player(name)
      set_dice(dice)
      set_saved(saved)
    end
    
    def roll(dice, name)
      set_current_player(name)
      
      set_dice(dice)
      set_saved(@@saved_dice) unless dice.length == 6
      
      # Wait for user input. Know a better way? Then tell me!
      $state = :wait
      while $state == :wait do
        if $app_status == :will_quit
          $state = :done
          return []
        end
      end
      $state = :sleep
      
      unmarked = get_dies("0")
      marked = get_dies("1")
      
      if marked.length == 0
        @@saved_dice = []
        []
      else
        @@saved_dice = marked
        unmarked
      end
    end
    
    def limits(limit, bust)
      @@limit_var.value = "Win: #{limit} Bust: #{bust}"
    end
    
    private
    
    def set_current_player(name)
      @@name_var.value = "Current player: #{name}"
    end
    
    def set_dice(dice)
      len = dice.length
      len = 6 if dice.length > 6
      len.times do |i|
        @@die_vars[i][DIE_VALUE].value = dice[i]
        @@die_vars[i][DIE_BUTTON].value = "0"
      end
    end
    
    def set_saved(dice)
      len = dice.length
      len = 6 if dice.length > 6
      len.times do |i|
        @@die_vars[5-i][DIE_VALUE].value = dice[i]
        @@die_vars[5-i][DIE_BUTTON].value = "1"
      end
    end
    
    def get_dies(bval)
      result = []
      6.times do |i|
        if @@die_vars[5-i][DIE_BUTTON].value.eql? bval
          result << @@die_vars[5-i][DIE_VALUE].value
        end
      end
      result
    end
  end
end