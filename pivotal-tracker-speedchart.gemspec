# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pivotal/tracker/speedchart/version'

Gem::Specification.new do |spec|
  spec.name          = "pivotal-tracker-speedchart"
  spec.version       = Pivotal::Tracker::Speedchart::VERSION
  spec.authors       = ["Tsuyoshi Ushio"]
  spec.email         = ["ushio@simplearchitect.com"]
  spec.description   = %q{Create speedchart from pivotal tracker}
  spec.summary       = %q{speed chart creator}
  spec.homepage      = "http://rubygems.org/gems/pivotal-tracker-speedchart"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "pivotal-tracker"
  spec.add_runtime_dependency "spreadsheet"
  spec.add_runtime_dependency "yard"
  spec.add_runtime_dependency "redcarpet"
  spec.add_runtime_dependency "gruff"


end
