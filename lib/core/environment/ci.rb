#!/usr/bin/env ruby

module SecureKeys
  module Core
    module Environment
      class CI
        # Fetches the value of the environment variable with the given key.
        # @param key [String] the key of the environment variable to fetch
        # @return [String] the value of the environment variable
        def fetch(key:)
          ENV[formatted_key(key:)]
        rescue StandardError
          puts "❌ Error fetching the key: #{key} from ENV variables"
        end

        private

        # Formats the key to match the format of the environment variables.
        # @param key [String] the key to format
        # @return [String] the formatted key
        def formatted_key(key:)
          key.gsub('-', '_').uppercase
        end
      end
    end
  end
end
