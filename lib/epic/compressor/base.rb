module Epic #:nodoc:
  # Compresses a file using the specified compressor/minifier (currently YUI Compressor 2.4.2).
  #
  # === Usage
  #
  #   Epic::Compressor.compress("filename.js")
  #
  #   Epic::Compressor.compress("filename.css")
  #
  # Outputs the compressed file to <tt>_path_.min.</tt>
  #
  # === Options
  # 
  #   "type"                "js" or "css". Identifies the file type. Only needed if the file does
  #                         not have a standard extension.
  #
  #   "obfuscate"           true or false. Change internal variable names within the code.
  #                         
  #   "verbose"             true or false. Output warnings about code quality.
  #
  #   "preserve_semi"       true or false. Preserve unnecessary semicolons.
  #
  # TODO: Make it support multiple compressors.
  #
  class Compressor < Epic::Base
    include Epic::Errors
    
    # The path of the original file being compressed.
    #      
    attr_accessor :path
    
    # The type of file, whether :js or :css.
    #
    attr_accessor :type
    
    # The type of compressor used--:yui or :closure
    #
    attr_accessor :compressor
    
    def initialize(path)
      @path = path
      
      raise "No such file or directory - #{path}" unless File.exists?(path)
      
      if path =~ /\.js$/
        @type = :js
      elsif path =~ /\.css$/
        @type = :css
      end
      @errors = []
    end
    
    def compressor
      configuration.compressor || :yui
    end
    
    def compress(params={})
      if compressor == :yui
        Epic::Compressor::YUI.new(path).compress(params)
      elsif compressor == :closure
        Epic::Compressor::Closure.new(path).compress(params)
      end
    end
  
    def compress_path(params)
      params.stringify_keys!
    
      $stdout.print "   #{compressed_display_path}  compressing . . . "
      compressed = ''
    
      options_string = convert_params_to_string(params)

      result = execute_compressor(options_string)

      parse_errors(result)

      if valid?
        $stdout.puts "OK"
      else
        display_errors
        raise "JavaScript errors in #{compressed_display_path}"
      end          
    end
    
    def parse_errors(result="")
      result.to_s.split("\n").each do |line|
        if line =~ error_regexp
          line_number = $1.to_i
          error = "Error at #{compressed_display_path} line #{line_number}: #{$2}"
          error += F.get_line_from_file(path, line_number)

          errors << error
        end
      end          
    end

    # join the options together for appending to the command line
    #
    def convert_params_to_string(params)
      options = parse_options(params)
      options.map {|k,v| "--#{k} #{v}"}.join(" ")
    end
    
    def compressed_path
      @compressed_path ||= "#{path}.min"
    end
  
    def compressed_display_path
      @compressed_display_path ||= display_path(path)
    end

    def vendor_path
      File.join(File.dirname(__FILE__), "..", "..", "..", "vendor")
    end
  end
end