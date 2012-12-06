# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'peter_parser/version'

Gem::Specification.new do |s|
  s.name        = 'peter_parser'
  s.version     = PeterParser::VERSION
  s.authors     = ['lggassert']
  s.email       = ['lggassert@gmail.com']
  s.homepage    = 'https://github.com/lggassert/peter-parser'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'mock_redis'
  s.add_runtime_dependency 'mechanize', ['~>2.5.1']
  s.add_runtime_dependency 'resque', ['~>1.20']
  s.add_runtime_dependency 'rake', ['0.9.2']
end
