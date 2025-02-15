#!/usr/bin/env ruby
# rubocop:disable Layout/HeredocIndentation

require_relative './swift'

module Keys
  module Swift
    class Writer
      private

      attr_accessor :mapped_keys, :secure_key_bytes, :key_file, :key_directory

      public

      # Initialize the writer with the mapped keys and the secure key bytes
      # @param mapped_keys [Array<Hash>] The mapped keys
      # @param secure_key_bytes [Array<UInt8>] The secure key bytes
      def initialize(mapped_keys:, secure_key_bytes:)
        self.mapped_keys = mapped_keys
        self.secure_key_bytes = secure_key_bytes
        self.key_file = "#{SWIFT_PACKAGE_NAME}.swift"
        self.key_directory = "#{SWIFT_PACKAGE_DIRECTORY}/Sources/#{SWIFT_PACKAGE_NAME}"
      end

      # Write the keys to the file
      def write
        # Write the file
        File.open("#{key_directory}/#{key_file}", 'w') do |file|
          file.write(key_swift_file_template(content: formatted_keys))
        end
      end

      private

      # Generate the formatted keys content using Swift code format
      # @return [String] The formatted keys content
      def formatted_keys
        <<~SWIFT
        #{mapped_keys.map { |key| case_key_declaration_template(name: key[:name]) }.join("\t")}
            case unknown

            // MARK: - Properties

            /// The decrypted value of the key
            public var decryptedValue: String {
                switch self {
                    #{mapped_keys.map { |key| switch_case_key_declaration_template(name: key[:name], value: key[:value], iv: key[:iv], tag: key[:tag]) }.join("\t\t\t")}
                    case .unknown: fatalError("Unknown key \\(rawValue)")
                }
            }
        SWIFT
      end

      # Generate the Swift file template
      # @param content [String] The content of the file
      # @return [String] The Swift file template
      def key_swift_file_template(content:)
        <<~SWIFT
        // swiftlint:disable all

        import Foundation
        import CryptoKit

        // MARK: - Global methods

        /// Fetch the decrypted value of the key
        ///
        /// - Parameter:
        ///    - key: The key to fetch the decrypted value for
        ///
        /// - Returns: The decrypted value of the key
        @available(iOS 13.0, *)
        public func key(for key: Keys) -> String { key.decryptedValue }

        /// Fetch the decrypted value of the key
        ///
        /// - Parameter:
        ///    - key: The key to fetch the decrypted value for
        ///
        /// - Returns: The decrypted value of the key
        @available(iOS 13.0, *)
        public func key(_ key: Keys) -> String { key.decryptedValue }

        // MARK: - Keys enum

        /// Keys is a class that contains all the keys that are used in the application.
        @available(iOS 13.0, *)
        public enum Keys: String {

            // MARK: - Cases

            #{content}
        }

        // MARK: - Decrypt keys from array extension

        @available(iOS 13.0, *)
        extension Array where Element == UInt8 {

            // MARK: - Methods

            func decrypt(key: [UInt8], iv: [UInt8], tag: [UInt8]) -> String {
                guard let sealedBox = try? AES.GCM.SealedBox(nonce: AES.GCM.Nonce(data: Data(iv)),
                                                             ciphertext: Data(self),
                                                             tag: Data(tag)),
                      let decryptedData = try? AES.GCM.open(sealedBox, using: SymmetricKey(data: Data(key))),
                      let decryptedKey = String(data: decryptedData, encoding: .utf8) else {
                    fatalError("Failed to decrypt the key")
                }
                return decryptedKey
            }
        }

        // MARK: - String extension for keys

        @available(iOS 13.0, *)
        extension String {

            // MARK: - Methods

            /// Fetch the key from the keys enum
            public var secretKey: Keys { Keys(rawValue: self) ?? .unknown }

            /// Fetch the decrypted value of the key
            ///
            /// - Parameters:
            ///    - key: The key to fetch the decrypted value for
            ///
            /// - Returns: The decrypted value of the key
            public static func key(for key: Keys) -> String { key.decryptedValue }
        }

        // swiftlint:enable all
        SWIFT
      end

      # Generate the case key declaration template
      # @param name [String] The name of the key
      def case_key_declaration_template(name:)
        <<~SWIFT
        case #{name}
        SWIFT
      end

      # Generate the switch case key declaration template
      # @param name [String] The name of the key
      def switch_case_key_declaration_template(name:, value:, iv:, tag:) # rubocop:disable Naming/MethodParameterName
        <<~SWIFT
        case .#{name}: #{value}.decrypt(key: #{secure_key_bytes}, iv: #{iv}, tag: #{tag})
        SWIFT
      end
    end
  end
end

# rubocop:enable Layout/HeredocIndentation
