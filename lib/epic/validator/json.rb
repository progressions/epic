module Epic #:nodoc:
  module Validator #:nodoc    
    class JSON < JavaScript
      def pre_process(output)
        output
      end
      
      def jslint_settings
        ""
      end
    end
  end
end