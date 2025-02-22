#!/usr/bin/env ruby

require 'optparse'
require_relative '../globals/globals'

module SecureKeys
  module Core
    module Console
      class ArgumentParser < OptionParser
        class << self
          attr_reader :arguments
        end

        # Configure the default arguments
        @arguments = {
          delimiter: nil,
          identifier: nil,
        }

        def initialize
          super('Usage: secure-keys [--options]')
          separator('')

          # Configure the arguement parser
          configure!
          order!(into: @arguments)
        end

        private

        def configure!
          on('-h', '--help', 'Use the provided commands to select the params') do
            puts self
            exit(0)
          end

          on('-d', '--delimiter DELIMITER', String, "The delimiter to use for the key access (default: \"#{Globals.default_key_delimiter}\")")
          on('-i', '--identifier IDENTIFIER', String, "The identifier to use for the key access (default: \"#{Globals.default_key_access_identifier}\")")

          on('-v', '--version', 'Show the secure-keys version') do
            puts "secure-keys version: v#{SecureKeys::VERSION}"
            exit(0)
          end
        end
      end
    end
  end
end
