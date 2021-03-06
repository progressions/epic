module Epic #:nodoc:
  class Compressor
    class YUI < Epic::Compressor
      def error_regexp
        /\[ERROR\] (\d+):\d+:(.*)/
      end
      
      def compress(params={})
        perform_compression(params)
      end
    
      # call the compressor
      #
      def execute_compressor(options_string)
        command = "java -jar #{compressor_path} #{options_string} #{path} -o \"#{destination}\" 2>&1"
        F.execute(command, :return => true)
      end

      # join the options together for appending to the command line
      #
      def convert_params_to_string(params)
        options = parse_options(params)
        options.map {|k,v| "--#{k} #{v}"}.join(" ")
      end

      # set options and defaults
      #
      def parse_options(options)
        options["type"] ||= type
        options["type"] = options["type"].to_s
      
        if options.delete("obfuscate")
          options["nomunge"] = ""
        end
        if options.delete("verbose")
          options["verbose"] = ""
        end
        options["charset"] = "utf-8"

        if options["type"] == "js" && !options["preserve_semi"]
          options["preserve-semi"] = ""
        end 
      
        options         
      end
  
      def compressor_path
        compressor_path = File.expand_path("#{vendor_path}/yuicompressor-2.4.2.jar")
        raise "#{compressor_path} does not exist" unless File.exists?(compressor_path)
        compressor_path
      end
    end
  end
end