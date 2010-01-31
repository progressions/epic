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
    
    # The path where the compressed file will be written.
    #
    attr_accessor :destination
    
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
    
    def perform_compression(params={})
      params.stringify_keys!
      
      @destination = params.delete("destination")
      
      # if the compressed_file exists, don't create it again
      #
      compress_path(params) unless File.exists?(destination)
    
      File.read(destination)      
    end
    
    def destination
      unless @destination
        @destination = "#{path}.min"
      end
      unless @destination =~ /^\//
        @destination = File.expand_path(@destination)
      end
      @destination
    end
  
    def compressed_display_path
      @compressed_display_path ||= display_path(path)
    end
  end
end