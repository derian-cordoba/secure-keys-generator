#!/usr/bin/env ruby

require_relative './core/globals/globals'
require_relative './core/environment/ci'
require_relative './core/environment/keychain'
require_relative './core/utils/swift/writer'
require_relative './core/utils/swift/package'
require_relative './core/utils/swift/swift'
require_relative './core/utils/swift/xcframework'
require_relative './core/utils/openssl/cipher'

module Keys
  class Generator
    private

    attr_accessor :cipher, :secrets_source, :secret_keys, :mapped_keys

    public

    def initialize
      # If the secure keys identifier is not set, set it to 'secure-keys'
      ENV['SECURE_KEYS_IDENTIFIER'] = 'secure-keys' unless ENV.key?('SECURE_KEYS_IDENTIFIER')

      puts "🔔 You're using a custom delimiter '#{Keys::Globals.key_delimiter}'" unless Keys::Globals.key_delimiter.eql?(Keys::Globals.default_key_delimiter)
      puts "🔔 You're using a custom key access identifier '#{Keys::Globals.key_access_identifier}'" unless Keys::Globals.key_access_identifier.eql?(Keys::Globals.default_key_access_identifier)

      # Configure cipher
      self.cipher = Keys::OpenSSL::Cipher.new

      # Configure the secret source based on the environment
      if Keys::Globals.ci?
        self.secrets_source = Keys::Core::Environment::CI.new
      else
        self.secrets_source = Keys::Core::Environment::Keychain.new
      end

      # Define the keys that we want to map
      self.secret_keys = secrets_source.fetch(key: Keys::Globals.key_access_identifier)
                                       .to_s
                                       .split(Keys::Globals.key_delimiter)
                                       .map(&:strip)

      # Add the keys that we want to map
      self.mapped_keys = secret_keys.map do |key|
        encrypted_data = cipher.encrypt(value: secrets_source.fetch(key:))
        # Convert the first key chart to downcase
        key[0] = key[0].downcase
        { name: key, **encrypted_data }
      end
    end

    def setup
      pre_actions

      package = Keys::Swift::Package.new
      package.generate

      writer = Keys::Swift::Writer.new(mapped_keys: mapped_keys,
                                       secure_key_bytes: cipher.secure_key_bytes)
      writer.write

      xcframework = Keys::Swift::XCFramework.new
      xcframework.generate

      post_actions
    end

    private

    def pre_actions
      # Remove the keys directory
      system("rm -rf #{Keys::Swift::KEYS_DIRECTORY}")
    end

    def post_actions
      # Remove the keys directory
      system("rm -rf #{Keys::Swift::SWIFT_PACKAGE_DIRECTORY}")

      # Remove the build directory
      system("rm -rf #{Keys::Swift::KEYS_DIRECTORY}/#{Keys::Swift::BUILD_DIRECTORY}")
    end
  end
end
