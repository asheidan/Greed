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
          TkFrame.new(self) do
            @@roll_button = TkButton.new(self) do
              text 'Roll'
              state :disabled
              command do
                $state = :roll if $state == :wait
              end
              pack :side => :left
            end
            @@stay_button = TkButton.new(self) do
              text 'Stay'
              state :disabled
              command do
                $state = :stay if $state == :wait
              end
              pack :side => :left
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
      set_current_player(name)
      set_dice(dice)
      set_saved(saved)
    end
    
    def roll(dice, name)
      set_button_state(:normal)
      
      # Wait for user input. Know a better way? Then tell me! 
      # How about a mutex? // een
      $state = :wait
      while $state == :wait do
        if $app_status == :will_quit
          $state = :done
          return []
        end
      end
      set_button_state(:disabled)
      if $state == :stay then
        $state = :sleep
        return []
      end
      $state = :sleep
      
      unmarked = get_dies("0")
      marked = get_dies("1")
      
      if marked.length == 6
        [nil]*6
      elsif marked.length == 0
        []
      else
        unmarked
      end
    end
    
    def limits(limit, bust)
      @@limit_var.value = "Win: #{limit} Bust: #{bust}"
    end
    
    def game_over(name, did_win)
      @@name_var.value = "#{name} won!"
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
          result << @@die_vars[5-i][DIE_VALUE].to_i
        end
      end
      result
    end
    
    def set_button_state(state)
      @@roll_button.state = state
      @@stay_button.state = state
    end
  end
end