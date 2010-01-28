module Epic
  module Validator
    class Base < Epic::Base
      attr_accessor :path, :errors
      
      def initialize(path=nil)
        @path = path
        @errors = []
      end
      
      def errors
        @errors ||= []
      end

      def display_errors
        errors.each do |err|
          $stdout.puts
          $stdout.puts err.to_s
        end        
      end
    end
    
    class HTML < Epic::Validator::Base
      def validator
        @validator ||= W3CValidators::MarkupValidator.new
      end
      
      def doctype
        configuration.doctype || "HTML 4.01 Transitional"
      end
      
      def validate(filename=nil)
        @path = filename || path
        $stdout.print "   #{display_path}  validating . . . "
        
        validator.set_doctype!(doctype)

        results = validator.validate_file(path)
        
        @errors = results.errors
        
        valid = results.errors.length <= 0
        
        if valid
          $stdout.puts "OK"
        else
          $stdout.puts "validation errors"
          display_errors
        end
        
        valid
      end
    end
    
    class JavaScript < Base
      def jslint_settings
        configuration.jslint_settings.to_s
      end
      
      def jslint_settings_count
        jslint_settings.to_s.split("\n").size
      end
      
      def pre_process(content)
        jslint_settings + content
      end
      
      def js_fragment_path
        File.expand_path("#{tmp_path}/#{File.basename(path)}_fragment")
      end

      def jslint_path
        jslint_path = File.expand_path("#{File.dirname(__FILE__)}/../../vendor/ext/jslint.js")
        raise "#{jslint_path} does not exist" unless File.exists?(jslint_path)
        jslint_path
      end
      
      def rhino_path
        rhino_path = File.expand_path("#{File.dirname(__FILE__)}/../../vendor/ext/js.jar")
        raise "#{rhino_path} does not exist" unless File.exists?(rhino_path)
        rhino_path
      end
      
      def valid_results?(results)
        fragment_display_path = display_path(js_fragment_path)
        unless results =~ /jslint: No problems found/
          results.split("\n").each do |result|
            if result =~ /line (\d+) character (\d+): (.*)/
              line_number = $1.to_i
              error = "Error at #{fragment_display_path} line #{line_number-jslint_settings_count} character #{$2}: #{$3}"
              error += F.get_line_from_file(js_fragment_path, line_number)
        
              errors << error
            end
          end
        end
        errors.length <= 0
      end
      
      def validate_path
        raw_output = File.read(path)        
        output = pre_process(raw_output)
        
        FileUtils.mkdir_p(tmp_path)
        
        File.open(js_fragment_path,'w') do |f|
          f.puts output
        end

        F.execute("java -jar #{rhino_path} #{jslint_path} #{js_fragment_path}", :return => true)
      end
      
      def validate(filename=nil)
        @path = filename || path
        $stdout.print "   #{display_path}  validating . . . "
        
        results = validate_path
        
        if valid_results?(results)
          $stdout.puts "OK"
        else
          $stdout.puts "errors found!"
          display_errors
        end
        
        errors.length <= 0
      end
    end
    
    class JSON < JavaScript
      def pre_process(output)
        output
      end
      
      def jslint_settings
      end
    end
    
    class Stylesheet < Base
      def validate(path=nil)
        true
      end
    end
  end
end