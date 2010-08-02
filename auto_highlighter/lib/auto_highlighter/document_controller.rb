module Redcar
  class AutoHighlighter
    class DocumentController

      attr_accessor :gc, :styledText, :document
      attr_accessor :height, :width, :highlighted  
      
      include Redcar::Document::Controller::CursorCallbacks
 
      def initialize
        @i = 0
        @highlighted_current = nil
        @highlighted_pair = nil
        @open_pair_chars = ["{", "(", "["]
        @close_pair_chars = ["}", ")", "]"]
        @pair_chars = @open_pair_chars + @close_pair_chars
      end

      def highlight_pair(current, pair)
        if document.length > 0
          if current == -1 and pair == -1
            puts "Paint redraw"
            current = @highlighted_current
            pair = @highlighted_pair
          elsif current == @highlighted_current || current == @highlighted_pair || pair == @highlighted_current || pair == @highlighted_pair
            return
          else
            clear
          end
          puts "Highligh on offset " + current.to_s() + " and its pair at " + pair.to_s()
          @pos_current = styledText.getLocationAtOffset(current)
          @pos_pair = styledText.getLocationAtOffset(pair)
          gc.background = ApplicationSWT.display.system_color Swt::SWT::COLOR_GRAY
          gc.setAlpha(98)
          rectangle1 = styledText.getTextBounds(current, current)
          rectangle2 = styledText.getTextBounds(pair, pair)
          gc.fill_rectangle(rectangle1)
          gc.fill_rectangle(rectangle2)          
          @highlighted_current = current
    	  @highlighted_pair = pair
	      @highlighted = true
        end
      end
      
      def clear
        if @highlighted
	      styledText.redrawRange(@highlighted_current, 1, false)
	      styledText.redrawRange(@highlighted_pair, 1, false) # if on the same line
          @highlighted_current = nil
          @highlighted_pair = nil
          @highlighted = false
        end
      end
      
      def find_forward_pair(offset, search_char, current_char)
        if offset == document.length
          return nil
        end

        state = 1
        quotes = false
        doublequotes = false
        
        while offset < document.length
          offset = offset + 1;
          @newchar = document.get_range(offset, 1)
          if @newchar == search_char and !quotes and !doublequotes
            state = state - 1
          elsif @newchar == current_char and !quotes and !doublequotes
            state = state + 1
          elsif @newchar == '"'
            doublequotes = !doublequotes
          elsif @newchar == "'"
            quotes = !quotes
          end
          if state == 0
            return offset
          end
        end
        
        if state != 0
          return nil
        end
      end

      def find_backwards_pair(offset, search_char, current_char)
        if offset == 0
          return nil
        end
        state = 1;
        quotes = false
        doublequotes = false
        

        while offset > 0
          offset = offset - 1;
          @newchar = document.get_range(offset, 1)
          if @newchar == search_char and !quotes and !doublequotes
            state = state - 1
          elsif @newchar == current_char and !quotes and !doublequotes
            state = state + 1
          elsif @newchar == '"'
            doublequotes = !doublequotes
          elsif @newchar == "'"
            quotes = !quotes
          end
          if state == 0
            return offset
          end
        end
        
        if state != 0
          return nil
        end
      end

      def pair_of_offset(offset)
        @char = document.get_range(offset, 1)
        @index = @open_pair_chars.index(@char)

        if @index
          @newoffset = find_forward_pair(offset, @close_pair_chars[@index], @open_pair_chars[@index])
        else
          @index = @close_pair_chars.index(@char)
          if @index
            @newoffset = find_backwards_pair(offset, @open_pair_chars[@index], @close_pair_chars[@index])
          end
        end
        return @newoffset
      end

      def cursor_moved(offset)
        
        if offset == document.length
            @char_next = false
        else
            @char_next = document.get_range(offset, 1)    
        end
        
        if offset > 0
            @char_prev = document.get_range(offset-1, 1) 
        else
            @char_prev = false
        end
        
        if @char_next and @pair_chars.include?(@char_next)
          highlight_pair(offset, pair_of_offset(offset))
	        @highlighted = true
        elsif @char_prev and @pair_chars.include?(@char_prev)
          highlight_pair(offset-1, pair_of_offset(offset-1))
	        @highlighted = true
        else
          clear
        end
      end
    end
  end
end
