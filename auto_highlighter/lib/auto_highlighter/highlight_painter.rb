module RedCar
 class AutoHighlighter
    
    @painter = PaintListener.new

    def self.edit_view_swt.paint_listeners
        @paint_listeners
    end

    class PaintListener
      def paintControl(event)
        puts "Paint!"  
        #event.gc.fill_polygon(triangle.to_java(:int))
      end
    
      def initialize()
      end
    end
  end
end
