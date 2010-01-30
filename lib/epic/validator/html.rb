module Epic #:nodoc:
  module Validator #:nodoc:  
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
        
        if valid?
          $stdout.puts "OK"
        else
          $stdout.puts "validation errors"
          display_errors
        end
        
        valid?
      end
    end
  end
end