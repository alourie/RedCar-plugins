require 'auto_highlighter/document_controller'
module Redcar
  class AutoHighlighter

    def self.styledText_update(styledText)        
      if @styledText != styledText
        puts "Style update"
        @styledText = styledText
        @doc.styledText = @styledText
        @doc.gc = Swt::Graphics::GC.new(@styledText)
      end
    end

    def self.document_cursor_listener
        @doc = DocumentController.new
    end
    
    #def	self.key_listener(styledText, doc)
	#    puts "Called key listener!"
    #  @key_listener = KeyListener.new(styledText, doc)
    #end

    #class PaintListener
	
   #   def initialize(styledText, doc_controller)
   #     @styledText = styledText
   #     @doc_controller = doc_controller
   #   end
        
   #   def paintControl(event)
   #     if styledText != @event
   #         @styledText = styledText
   #         doc_controller.styledText = @styledText
   #     end
   #   end
   # end
  end
end
