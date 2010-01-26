dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'rubygems'
require 'f'
require 'g'
require 'active_support'
require 'w3c_validators'

require 'epic/base'
require 'epic/validator'
require 'epic/compressor'
