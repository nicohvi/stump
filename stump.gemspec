# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stump/version'

Gem::Specification.new do |spec|
  spec.name          = 'stump'
  spec.version       = Stump::VERSION
  spec.authors       = ['Nicolay Hvidsten']
  spec.email         = ['nicohvi@gmail.com']
  spec.description   = 'Minute logging gem for small rack applications'
  spec.summary       = 'Log all the things!'
  spec.homepage      = 'http://nplol.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
