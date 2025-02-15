#!/usr/bin/env ruby

require 'osx_keychain'

module Keys
  module Core
    module Environment
      class Keychain
        private

        attr_accessor :keychain

        public

        def initialize
          self.keychain = OSXKeychain.new
        end

        # Fetches the value of the keychain access item with the given key.
        # @param key [String] the key of the keychain access item to fetch
        # @return [String] the value of the keychain access item
        def fetch(key:)
          keychain[key, Keys::Globals.key_access_identifier]
        rescue StandardError
          puts "❌ Error fetching the key: #{key} from Keychain."
        end
      end
    end
  end
end
