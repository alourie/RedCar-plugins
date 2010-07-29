require 'auto_highlighter/document_controller'
module Redcar
  class AutoHighlighter

    attr_accessor :gc

    def self.edit_view_swt_paint_listeners(doc)
      @paint_listener = PaintListener.new(doc)
    end

    def self.document_controller_types
      [AutoHighlighter::DocumentController]
    end
    
    class PaintListener
      def initialize(doc)
        @document = doc
      end
    
      def paintControl(event)
        puts "paint!!!"
        AutoHighlighter.gc=event.gc
      end
    end
  end
end
