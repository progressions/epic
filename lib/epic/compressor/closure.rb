module Epic #:nodoc:
  class Compressor
    class Closure < Epic::Compressor
      def error_regexp
        /(\d+)\: ERROR - (.*)/
      end
      
      def compress(params={})
        perform_compression(params)
      end
    
      # call the compressor
      #
      def execute_compressor(options_string)
        command = "java -jar #{compressor_path} --js #{path} -js_output_file #{destination} 2>&1"
        result = F.execute(command, :return => true)          
      end
      
      def convert_params_to_string(params={})
        ""
      end

      # set options and defaults
      #
      def parse_options(options)
        {}       
      end
  
      def compressor_path
        @compressor_path ||= File.expand_path("#{vendor_path}/compiler.jar")
        raise "#{@compressor_path} does not exist" unless File.exists?(@compressor_path)
        @compressor_path
      end
    end
  end
end