module Redcar
  class AutoHighlighter
    class KeyListenerHighlight 

      OpenPairChars = ["{", "(", "["]
      ClosePairChars = ["}", ")", "]"]
      PairChars = OpenPairChars + ClosePairChars
        
      def initialize(styledText, document, paint)
	@styledText = styledText
  	@background = @styledText.getBackground
        @document = document
	@paint = paint
      end
    
      def find_forward_pair(offset, search_char, current_char)
        if offset == @document.length
          return nil
        end

        state = 1
        quotes = false
        doublequotes = false
        
        while offset < @document.length
          offset = offset + 1;
          @newchar = @document.get_range(offset, 1)
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
          @newchar = @document.get_range(offset, 1)
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
        @char = @document.get_range(offset, 1)
        @index = OpenPairChars.index(@char)

        if @index
          @newoffset = find_forward_pair(offset, ClosePairChars[@index], OpenPairChars[@index])
        else
          @index = ClosePairChars.index(@char)
          if @index
            @newoffset = find_backwards_pair(offset, OpenPairChars[@index], ClosePairChars[@index])
          end
        end
        return @newoffset
      end

      def key_pressed()
	
	@offset = @document.cursor_offset
	if @paint.gc
	  #square = [0, 300, 300, 300, 300, 600, 0, 600]
	  #@paint.gc.setAlpha(95)
	  #@paint.gc.fill_polygon(square.to_java(:int))
	  puts "Not disposed!" if not @paint.gc.is_disposed?
	end
        puts "Offset is " + @offset.to_s() + ", Doc is " + @document.length.to_s()
        #puts "GC obj is " + gc.to_s()
        if @offset == @document.length
            @char_next = false
	    if @background != @styledText.getBackground
	      @styledText.setBackground(@background)
	    end
        else
            @char_next = @document.get_range(@offset, 1)    
        end
        
        if @offset > 0
            @char_prev = @document.get_range(@offset-1, 1) 
        else
            @char_prev = false
	    if @background != @styledText.getBackground
	      @styledText.setBackground(@background)
	    end
        end
        
        
        if @char_next and PairChars.include?(@char_next)
	  @styledText.setBackground(ApplicationSWT.display.system_color Swt::SWT::COLOR_DARK_GRAY)
          puts "Highligh " + @char_next + " on offset " + @offset.to_s() + " and its pair at " + pair_of_offset(@offset).to_s()
	  @styledText.redrawRange(pair_of_offset(@offset), 1, false)
          # highligh_pair(offset, pair_of_offset(offset))
        elsif @char_prev and PairChars.include?(@char_prev)
            puts "Highligh " + @char_prev + " on offset " + @offset.to_s() + " and its pair at " + pair_of_offset(@offset-1).to_s()
          # highligh_pair(offset-1, pair_of_offset(offset-1))
	  @styledText.redrawRange(pair_of_offset(@offset-1), 1, false)
        else
            #clear!
        end
      end

      def key_released(_)
      end

      #def highlight_pair(current_offset, pair_offset)
	#@styleText.
      #end

    end
  end
end
