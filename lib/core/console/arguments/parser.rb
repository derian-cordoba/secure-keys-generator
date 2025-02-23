#!/usr/bin/env ruby

require 'optparse'
require_relative '../../globals/globals'
require_relative './handler'

module SecureKeys
  module Core
    module Console
      module Argument
        class Parser < OptionParser
          # Initialize the argument parser with the default options
          def initialize
            super('Usage: secure-keys [--options]')
            separator('')

            # Configure the arguement parser
            configure!
            parse!(into: Handler.arguments)
          end

          private

          # Configure the argument parser
          def configure!
            on('-h', '--help', 'Use the provided commands to select the params') do
              puts self
              exit(0)
            end

            on('-d', '--delimiter DELIMITER', String, "The delimiter to use for the key access (default: \"#{Globals.default_key_delimiter}\")")
            on('-i', '--identifier IDENTIFIER', String, "The identifier to use for the key access (default: \"#{Globals.default_key_access_identifier}\")")
            on('-vv', '--verbose', TrueClass, 'Enable verbose mode')

            on('-v', '--version', 'Show the secure-keys version') do
              puts "secure-keys version: v#{SecureKeys::VERSION}"
              exit(0)
            end
          end
        end
      end
    end
  end
end
