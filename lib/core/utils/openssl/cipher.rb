#!/usr/bin/env ruby

require 'openssl'
require 'base64'
require 'securerandom'

module SecureKeys
  module OpenSSL
    class Cipher
      private

      attr_accessor :secure_key, :cipher

      public

      # Initialize the cipher with a random generated key
      # and the aes-256-gcm algorithm
      # @param bytes [Integer] the number of bytes to generate the key
      def initialize(bytes: 32)
        self.secure_key = SecureRandom.random_bytes(bytes)
        self.cipher = ::OpenSSL::Cipher.new('aes-256-gcm').encrypt

        # Configure the cipher key using the random generated key
        cipher.key = secure_key
      end

      # Encrypt a value using the cipher
      # @param value [String] the value to encrypt
      # @return [Hash] the encrypted value, the iv and the tag
      def encrypt(value:)
        iv = cipher.random_iv
        encrypted_value = cipher.update(value) + cipher.final
        tag = cipher.auth_tag

        { iv: iv.bytes, value: encrypted_value.bytes, tag: tag.bytes }
      end

      # Fetch the bytes of the secure key
      # @return [Array] the bytes of the secure key
      def secure_key_bytes
        secure_key.bytes
      end
    end
  end
end
