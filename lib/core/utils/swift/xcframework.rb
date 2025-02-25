#!/usr/bin/env ruby

require 'xcodeproj'
require_relative './swift'
require_relative '../../globals/globals'
require_relative '../../console/shell'
require_relative '../../console/logger'
require_relative '../../console/arguments/handler'

module SecureKeys
  module Swift
    class XCFramework
      # Generate the XCFramework from the Swift package
      def generate
        # TODO: Add support for multiple platforms
        # Currently this is failling with the following error:
        # "library with the identifier 'ios-arm64' already exists."
        %w[Release].each do |configuration|
          Globals.ios_platforms.each do |platform|
            generate_key_modules(configuration:, platform:)
            generate_key_libraries(configuration:, platform: platform[:path])
          end
        end
        generate_key_xcframework
        add_xcframework_to_xcodeproj_target_if_needed
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

        Core::Console::Shell.sh(command:)
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

        Core::Console::Shell.sh(command:)
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

        Core::Console::Shell.sh(command:)
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

      # Add the XCFramework to the Xcode project target if needed
      # @param target_name [String] The target name to add the XCFramework
      def add_xcframework_to_xcodeproj_target_if_needed(target_name: nil)
        target_name ||= Core::Console::Argument::Handler.fetch(key: :target)

        return if target_name.to_s.empty?

        xcodeproj = Xcodeproj::Project.open(SecureKeys::Globals.xcodeproj_path)
        return Core::Console::Logger.error(message: "The xcodeproj #{xcodeproj} already have the #{XCFRAMEWORK_DIRECTORY}") if xcodeproj_has_secure_keys_xcframework?(xcodeproj:)

        Core::Console::Logger.important(message: "Adding the XCFramework to the target '#{target_name}'")
        xcodeproj_target = xcodeproj.targets.find { |target| target.name.eql?(target_name) }

        Core::Console::Logger.crash!(message: "The target #{target_name} was not found") if xcodeproj_target.nil?

        xcframework_ref = xcodeproj.frameworks_group.new_file(XCFRAMEWORK_DIRECTORY)
        xcodeproj_target.frameworks_build_phase.add_file_reference(xcframework_ref)

        xcodeproj.save
      end

      # Check if the Xcode project has the secure keys XCFramework
      # @param xcodeproj [Xcodeproj::Project] The Xcode project
      # @return [Bool] true if the Xcode project has the secure keys XCFramework
      def xcodeproj_has_secure_keys_xcframework?(xcodeproj:)
        xcodeproj.targets.each do |target|
          target.frameworks_build_phase.files.each do |file|
            next if file.file_ref.nil?

            return true if file.file_ref.path.include?(XCFRAMEWORK_DIRECTORY)
          end
        end
        false
      end
    end
  end
end
