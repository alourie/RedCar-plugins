require 'auto_highlighter/highlight_painter'
module Redcar
  class AutoHighlighter

    @paint_flag = nil

    def self.paint_listener()
      puts "Called paint!"
      @paint_listener = PaintListener.new()
    end

    #def self.document_controller_types
    #  puts "Called docContr"
    #  [AutoHighlighter::DocumentController]
    #end
    
    def	self.key_listener(styledText, doc, paint)
	    puts "Called key listener!"
      @key_listener = KeyListener.new(styledText, doc, paint)
    end

    class KeyListener
      
      def initialize(styledText, doc, paint)
        @key_handler = KeyListenerHighlight.new(styledText, doc, paint)
      end
      
      def key_pressed(_)
        @key_handler.key_pressed        
      end
      
      def key_released(_)
        
      end
    end
    
    class PaintListener
	
      attr_accessor :gc

      def paintControl(event)
	      @gc = event.gc
      end
    end
  end
end
