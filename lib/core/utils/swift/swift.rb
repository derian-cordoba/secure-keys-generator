#!/usr/bin/env ruby

module SecureKeys
  module Swift
    # Constants

    # The name of the directory that contains the keys
    KEYS_DIRECTORY = '.keys'.freeze

    # The name of the directory that contains the generated build
    BUILD_DIRECTORY = 'Build'.freeze

    # The name of the Swift Package
    SWIFT_PACKAGE_NAME = 'Keys'.freeze

    # The name of the directory that contains the generated Swift package
    SWIFT_PACKAGE_DIRECTORY = "#{KEYS_DIRECTORY}/Package".freeze

    # The name of the directory that contains the generated xcframework
    XCFRAMEWORK_DIRECTORY = "#{SWIFT_PACKAGE_NAME}.xcframework".freeze
  end
end
