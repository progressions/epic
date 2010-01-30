module Epic #:nodoc:
  module Validator #:nodoc:
    class Base < Epic::Base
      include Epic::Errors
      
      attr_accessor :path, :errors
      
      def initialize(path=nil)
        @path = path
        @errors = []
      end
    end
  end
end