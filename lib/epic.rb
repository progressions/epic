dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'epic'))

require 'rubygems'
require 'f'
require 'g'
require 'active_support'
require 'w3c_validators'

require 'base'
require 'errors'
require 'validator'
require 'compressor'
