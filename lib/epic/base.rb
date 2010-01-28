module Epic #:nodoc
  class Configuration
    attr_accessor :base_path, :tmp_path, :doctype, :jslint_settings
  end
  
  class Base
    class << self
      def configuration
        @configuration ||= Epic::Configuration.new
      end
    
      def configure
        yield configuration
      end

      # Parses out the <tt>base_path</tt> setting from a path to display it in a
      # less verbose way.
      #
      def display_path(filename=nil)
        filename ||= path
        display_path = File.expand_path(filename)
        display_path.gsub(base_path.to_s, "")
      end
    
      def base_path
        configuration.base_path
      end
    end

    def configuration
      Epic::Base.configuration
    end

    # Parses out the <tt>base_path</tt> setting from a path to display it in a
    # less verbose way.
    #
    def display_path(filename=nil)
      filename ||= path
      display_path = File.expand_path(filename)
      display_path.gsub(base_path.to_s, "")
    end
    
    def base_path      
      configuration.base_path || ""
    end
    
    def tmp_path
      configuration.tmp_path || "#{base_path}/tmp" || ""
    end
  end
end