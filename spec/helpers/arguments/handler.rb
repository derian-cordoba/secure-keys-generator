# Handler extension to update the arguments values
# This helper is used only for testing purposes
module SecureKeys
  module Core
    module Console
      module Argument
        class Handler
          # Set the value of the key
          # @param key [Symbol] the key to be updated
          # @param value [String] the value to be updated
          def self.set(key:, value:)
            @arguments[key.to_sym] = value
          end
        end
      end
    end
  end
end
