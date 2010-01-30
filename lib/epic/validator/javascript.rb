module Epic #:nodoc:
  module Validator #:nodoc
    class JavaScript < Epic::Validator::Base
      def jslint_settings
        configuration.jslint_settings.to_s
      end
      
      def jslint_settings_count
        jslint_settings.split("\n").size
      end
      
      def pre_process(content)
        jslint_settings + content
      end
      
      def js_fragment_path
        File.expand_path("#{tmp_path}/#{File.basename(path)}_fragment")
      end

      def jslint_path
        jslint_path = File.expand_path("#{vendor_path}/ext/jslint.js")
        raise "#{jslint_path} does not exist" unless File.exists?(jslint_path)
        jslint_path
      end
      
      def rhino_path
        rhino_path = File.expand_path("#{vendor_path}/ext/js.jar")
        raise "#{rhino_path} does not exist" unless File.exists?(rhino_path)
        rhino_path
      end
      
      def vendor_path
        File.join(File.dirname(__FILE__), "..", "..", "..", "vendor")
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
  end
end