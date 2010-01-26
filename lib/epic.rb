require 'rubygems'
require 'lib/file'
require 'g'
require 'active_support'
require 'w3c_validators'

module Epic
  module Validator
    class Configuration
      attr_accessor :base_path, :tmp_path, :doctype, :jslint_settings
    end
    
    class Base
      class << self
        def configuration
          @@configuration ||= Epic::Validator::Configuration.new
        end
      
        def configure
          yield configuration
        end
      end

      def configuration
        self.class.configuration
      end

      # Parses out the <tt>base_path</tt> setting from a path to display it in a
      # less verbose way.
      #
      def display_path(path)
        path = File.expand_path(path)
        path.gsub(base_path.to_s, "")
      end
      
      def base_path      
        configuration.base_path || ""
      end
      
      def tmp_path
        configuration.tmp_path || ""
      end
    end
    
    class HTML < Base
      def validator
        @validator ||= W3CValidators::MarkupValidator.new
      end
      
      def validate(path)
        $stdout.print "   #{path}  validating . . . "
        
        doctype = configuration.doctype || "HTML 4.01 Transitional"
        validator.set_doctype!(doctype)

        results = validator.validate_file(path)
        
        valid = results.errors.length <= 0
        
        if valid
          $stdout.puts "OK"
        else
          $stdout.puts "validation errors"
          results.errors.each do |err|
            $stdout.puts
            $stdout.puts err.to_s
          end
        end
        
        valid
      end
    end
    
    class JavaScript < Base
      def use_jslint_settings?
        !jslint_settings.blank?
      end
      
      def jslint_settings
        configuration.jslint_settings
      end
      
      def jslint_settings_count
        jslint_settings.to_s.split("\n").size
      end
      
      def pre_process(content)
        content
      end
    
      def validate(path)
        display = display_path(path)
        $stdout.print "   #{display}  validating . . . "
        output = ""
      
        File.open(path) do |f|
          output = f.read
        end
        
        output = pre_process(output)
        
        FileUtils.mkdir_p(tmp_path)
        
        js_fragment_path = File.expand_path("#{tmp_path}/#{File.basename(path)}_fragment")
        fragment_display_path = display_path(js_fragment_path)
    
        if File.exists?(js_fragment_path)
          puts "That already exists?"
        else
          File.open(js_fragment_path,'w') do |f|
            f.puts jslint_settings if use_jslint_settings?
            f.puts output
          end

          jslint_path = File.expand_path("#{File.dirname(__FILE__)}/../vendor/ext/jslint.js")
          raise "#{jslint_path} does not exist" unless File.exists?(jslint_path)
          rhino_path = File.expand_path("#{File.dirname(__FILE__)}/../vendor/ext/js.jar")
          raise "#{rhino_path} does not exist" unless File.exists?(rhino_path)
          
          results = F.execute("java -jar #{rhino_path} #{jslint_path} #{js_fragment_path}", :return => true)

          if results =~ /jslint: No problems found/
            $stdout.puts "OK"
          else
            $stdout.puts "errors found!"
            results.split("\n").each do |result|
              if result =~ /line (\d+) character (\d+): (.*)/
                line_number = $1.to_i
                error = "Error at #{fragment_display_path} line #{line_number-jslint_settings_count} character #{$2}: #{$3}"
                error += F.get_line_from_file(js_fragment_path, line_number)
          
                $stdout.puts error
              end
            end
            message = "JavaScript Errors embedded in #{display}"
            g(message)
            raise message
          end
        end
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
      def validate(filename)
        true
      end
    end
  end
end