#!/usr/bin/env ruby

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "#{Dir.pwd}/lib/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.3'
  spec.required_rubygems_version = Gem::Requirement.new('>= 0'.freeze) if spec.respond_to? :required_rubygems_version=

  spec.name           = 'secure-keys'
  spec.version        = SecureKeys::VERSION
  spec.authors        = ['Derian Córdoba']
  spec.email          = ['derianricardo451@gmail.com']
  spec.summary        = SecureKeys::SUMMARY
  spec.description    = SecureKeys::DESCRIPTION
  spec.license        = 'MIT'
  spec.homepage       = SecureKeys::HOMEPAGE_URI
  spec.bindir         = 'bin'
  spec.require_paths  = %w[*/lib]
  spec.platform       = Gem::Platform::RUBY
  spec.metadata       = {
    'bug_tracker_uri' => "#{SecureKeys::HOMEPAGE_URI}/issues",
    'documentation_uri' => "#{SecureKeys::HOMEPAGE_URI}/blob/main/README.md",
    'homepage_uri' => SecureKeys::HOMEPAGE_URI,
    'source_code_uri' => SecureKeys::HOMEPAGE_URI,
    'changelog_uri' => "#{SecureKeys::HOMEPAGE_URI}/releases"
  }

  spec.files = Dir.glob('*/lib/**/*',
                        File::FNM_DOTMATCH) + Dir['bin/*'] + Dir['*/README.md'] + %w[README.md]
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }

  spec.add_runtime_dependency 'base64', '~> 0.2.0'
  spec.add_runtime_dependency 'colorize', '~> 1.1.0'
  spec.add_runtime_dependency 'digest', '~> 3.2.0'
  spec.add_runtime_dependency 'dotenv', '~> 3.1.7'
  spec.add_runtime_dependency 'json', '~> 2.10.1'
  spec.add_runtime_dependency 'logger', '~> 1.6.6'
  spec.add_runtime_dependency 'open3', '~> 0.2.1'
  spec.add_runtime_dependency 'optparse', '~> 0.6.0'
  spec.add_runtime_dependency 'osx_keychain', '~> 1.0.2'
  spec.add_runtime_dependency 'tty-screen', '~> 0.8.2'
  spec.add_runtime_dependency 'xcodeproj', '~> 1.27.0'
  spec.add_development_dependency 'rspec', '~> 3.13.0'
  spec.add_development_dependency 'rubocop', '~> 1.71.2'
  spec.add_development_dependency 'ruby-debug-ide', '~> 0.7.5'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
end
