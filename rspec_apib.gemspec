# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_apib/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-apib"
  spec.version       = RspecApiB::VERSION
  spec.authors       = ["Hoa Nguyen"]
  spec.email         = ["nvh0412@gmail.com"]
  spec.description   = %q{Autogeneration of apib file from rspec}
  spec.summary       = %q{Autogeneration of apib file from rspec}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'rspec'
end
