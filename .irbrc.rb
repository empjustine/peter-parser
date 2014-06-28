$:.push File.expand_path('../lib', __FILE__)
$:.push File.expand_path('../test', __FILE__)


require 'simplecov'
require 'test/unit'
SimpleCov.start do
  add_filter '/vendor/'
end

require 'peter_parser'
require 'test_core_patches'
require 'test_nodeset_parser'
require 'test_parser'