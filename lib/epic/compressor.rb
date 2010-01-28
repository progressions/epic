module Epic #:nodoc:
  module Compressor #:nodoc:
    # Compresses a file using the specified compressor/minifier (currently YUI Compressor 2.4.2).
    #
    # === Usage
    #
    #   Epic::Compressor::Base.compress("filename.js", "type" => "js")
    #
    #   Epic::Compressor::Base.compress("filename.css", "type" => "css")
    #
    # Outputs the compressed file to <tt>_path_.min.</tt>
    #
    # === Options
    # 
    #   "type"::              "js" or "css". Identifies the file type.
    #
    #   "obfuscate"::         true or false. Change internal variable names within the code.
    #                         
    #   "verbose"::           true or false. Output warnings about code quality.
    #
    #   "preserve_semi"::     true or false. Preserve unnecessary semicolons.
    #
    # TODO: Make it support multiple compressors.
    #
    # TODO: Convert it to an object, so you instantiate the Compressor class and then call it
    # on a file or a string.
    #
    class Base < Epic::Base
      def self.compress(path, options={})
        options.stringify_keys!
        compressed_display_path = display_path(path)
        compressed_path = "#{path}.min"
      
        options["type"] ||= "js"
        options["type"] = options["type"].to_s
        
        # if the compressed_file exists, don't create it again
        #
        unless File.exists?(compressed_path)
          $stdout.print "   #{compressed_display_path}  compressing . . . "
          compressed = ''
        
          # set options and defaults
          #
          if options.delete("obfuscate")
            options["nomunge"] = ""
          end
          if options.delete("verbose")
            options["verbose"] = ""
          end
          options["charset"] = "utf-8"
        
          if options["type"].to_s == "js" && !options["preserve_semi"]
            options["preserve-semi"] = ""
          end
        
          # join the options together for appending to the command line
          #
          options_string = options.map {|k,v| "--#{k} #{v}"}.join(" ")
      
          # call the compressor
          #
          compressor_path = File.expand_path("#{File.dirname(__FILE__)}/../../vendor/ext/yuicompressor-2.4.2.jar")
          raise "#{compressor_path} does not exist" unless File.exists?(compressor_path)
          
          command = "java -jar #{compressor_path} #{options_string} #{path} -o #{compressed_path} 2>&1"
          result = F.execute(command, :return => true)
        
          result.split("\n").each do |line|
            if line =~ /\[ERROR\] (\d+):(\d+):(.*)/
              line_number = $1.to_i
              error = "Error at #{compressed_display_path} line #{line_number} character #{$2}: #{$3}"
              error += F.get_line_from_file(path, line_number)
        
              $stdout.puts error
              g(error)
            end
          end
          
          if result =~ /ERROR/
            raise "JavaScript errors in #{compressed_display_path}"
          else
            $stdout.puts "OK"
          end
        end
        File.read(compressed_path)
      end
    end
    
    # Compresses a CSS file using the specified compressor/minifier (currently YUI Compressor 2.4.2).
    #
    # === Usage
    #
    #   Epic::Compressor::Stylesheet.compress("filename.css")
    #
    class Stylesheet < Base
      def self.compress(path)
        super(path, "type" => "css")
      end
    end
    
    # Compresses a JavaScript file using the specified compressor/minifier (currently YUI Compressor 2.4.2).
    #
    # === Usage
    #
    #   Epic::Compressor::JavaScript.compress("filename.js")
    #
    class JavaScript < Base
      # TODO: Add options hash   
      def self.compress(filename)
        super(filename, "type" => "js")
      end
    end
  end
end