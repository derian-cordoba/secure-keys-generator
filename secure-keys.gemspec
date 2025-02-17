#!/usr/bin/env ruby

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "#{Dir.pwd}/lib/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.3'
  spec.required_rubygems_version = Gem::Requirement.new('>= 0'.freeze) if spec.respond_to? :required_rubygems_version=

  spec.name           = 'secure-keys'
  spec.version        = Keys::VERSION
  spec.authors        = ['Derian Córdoba']
  spec.email          = ['derianricardo451@gmail.com']
  spec.summary        = Keys::SUMMARY
  spec.description    = Keys::DESCRIPTION
  spec.license        = 'MIT'
  spec.homepage       = Keys::HOMEPAGE_URI
  spec.bindir         = 'bin'
  spec.require_paths  = %w[*/lib]
  spec.platform       = Gem::Platform::RUBY

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"

  spec.files = Dir.glob('*/lib/**/*',
                        File::FNM_DOTMATCH) + Dir['bin/*'] + Dir['*/README.md'] + %w[README.md]
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }

  spec.add_runtime_dependency 'base64', '~> 0.2.0'
  spec.add_runtime_dependency 'digest', '~> 3.2.0'
  spec.add_runtime_dependency 'dotenv', '~> 3.1.7'
  spec.add_runtime_dependency 'json', '~> 2.10.1'
  spec.add_runtime_dependency 'osx_keychain', '~> 1.0.2'
  spec.add_development_dependency 'rubocop', '~> 1.71.2'
end
