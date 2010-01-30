module Epic #:nodoc:
  module Errors #:nodoc: 
    def errors
      @errors ||= []
    end
    
    def valid?
      errors.empty?
    end

    def display_errors
      errors.each do |err|
        $stdout.puts
        $stdout.puts err.to_s
      end        
    end
  end
end