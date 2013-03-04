# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'one_password/version'

Gem::Specification.new do |spec|
  spec.name          = 'one_password'
  spec.version       = OnePassword::VERSION
  spec.authors       = ['Alexander Semyonov']
  spec.email         = %w(al@semyonov.us)
  spec.description   = %q{File to operate with 1Password's Agile Keychain}
  spec.summary       = %q{1Password Agile Keychain support for Ruby}
  spec.homepage      = 'https://github.com/alsemyonov/one_password'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'pbkdf2'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'yard'
end
