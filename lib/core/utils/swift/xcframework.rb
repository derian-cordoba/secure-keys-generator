#!/usr/bin/env ruby

require_relative './swift'
require_relative '../../globals/globals'

module SecureKeys
  module Swift
    class XCFramework
      # Generate the XCFramework from the Swift package
      def generate
        # TODO: Add support for multiple platforms
        # Currently this is failling with the following error:
        # "library with the identifier 'ios-arm64' already exists."
        %w[Release].each do |configuration|
          SecureKeys::Globals.ios_platforms.each do |platform|
            generate_key_modules(configuration:, platform:)
            generate_key_libraries(configuration:, platform: platform[:path])
          end
        end
        generate_key_xcframework
      end

      private

      # Generate the Swift package modules
      # @param configuration [String] The configuration to build
      # @param platform [Hash] The platform to build
      def generate_key_modules(configuration:, platform:)
        command = <<~BASH
          cd #{SWIFT_PACKAGE_DIRECTORY} &&
          xcodebuild -scheme #{SWIFT_PACKAGE_NAME} \
            -sdk #{platform[:path]} \
            -destination generic/platform="#{platform[:name]}" \
            -configuration #{configuration} \
            ARCHS="arm64" BUILD_DIR="../#{BUILD_DIRECTORY}"
        BASH

        system(command)
      end

      # Generate the Swift package libraries
      # @param configuration [String] The configuration to build
      # @param platform [String] The platform to build
      def generate_key_libraries(configuration:, platform:)
        command = <<~BASH
          cd #{KEYS_DIRECTORY} &&
          ar -crs #{BUILD_DIRECTORY}/#{configuration}-#{platform}/lib#{SWIFT_PACKAGE_NAME}.a \
            #{BUILD_DIRECTORY}/#{configuration}-#{platform}/#{SWIFT_PACKAGE_NAME}.o
        BASH

        system(command)
      end

      # Generate the XCFramework from the Swift package libraries
      def generate_key_xcframework
        command = <<~BASH
          cd #{KEYS_DIRECTORY} &&
          xcodebuild -create-xcframework \
            #{xcframework_library_command} \
            -allow-internal-distribution \
            -output #{XCFRAMEWORK_DIRECTORY}
        BASH

        system(command)
      end

      # Generate the XCFramework library command
      # @return [String] The XCFramework library command
      def xcframework_library_command
        # TODO: Add support for multiple platforms
        # Currently this is failling with the following error:
        # "library with the identifier 'ios-arm64' already exists."
        %w[Release].map do |configuration|
          SecureKeys::Globals.ios_platforms.map do |platform|
            "-library #{BUILD_DIRECTORY}/#{configuration}-#{platform[:path]}/lib#{SWIFT_PACKAGE_NAME}.a"
          end.join(' ')
        end.join(' ')
      end
    end
  end
end
