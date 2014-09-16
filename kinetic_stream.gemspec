# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kinetic_stream/version'

Gem::Specification.new do |spec|
  spec.name          = "kinetic_stream"
  spec.version       = KineticStream::VERSION
  spec.authors       = ["Garfiny"]
  spec.email         = ["garfiny@"]
  spec.summary       = %q{}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.1.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"

  spec.add_dependency "aws-sdk"
end
