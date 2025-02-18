#!/usr/bin/env ruby

module SecureKeys
  module Globals
    module_function

    # Source: https://github.com/fastlane/fastlane/blob/b626fb18597eee88de0e08beba77070e2fecc299/fastlane_core/lib/fastlane_core/helper.rb#L73
    # Check if the current build is running on a CI
    # @return [Bool] true if the current build is running on a CI
    def ci?
      return true if circle_ci?

      # Check for Jenkins, Travis CI, ... environment variables
      %w[JENKINS_HOME JENKINS_URL TRAVIS CI APPCENTER_BUILD_ID TEAMCITY_VERSION GO_PIPELINE_NAME bamboo_buildKey GITLAB_CI XCS TF_BUILD GITHUB_ACTION GITHUB_ACTIONS BITRISE_IO BUDDY CODEBUILD_BUILD_ARN].any? do |current|
        ENV[current].to_s.eql?('true')
      end
    end

    # Check if the current build is running on CircleCI
    # @return [Bool] true if the current build is running on CircleCI
    def circle_ci?
      ENV.key?('CIRCLECI')
    end

    # Returns the supported iOS platforms
    # @return [Array] supported iOS platforms
    def ios_platforms
      [
        {
          name: 'iOS Simulator',
          path: 'iphonesimulator'
        },
        {
          name: 'iOS',
          path: 'iphoneos'
        }
      ]
    end

    # Returns the identifier to get all the key names
    # @return [String] key access identifier
    def key_access_identifier
      ENV['SECURE_KEYS_IDENTIFIER'] || default_key_access_identifier
    end

    # Returns the default key access identifier
    # @return [String] default key access identifier
    def default_key_access_identifier
      'secure-keys'
    end

    # Returns the keys delimiter
    # @return [String] keys delimiter
    def key_delimiter
      ENV['SECURE_KEYS_DELIMITER'] || default_key_delimiter
    end

    # Returns the default keys delimiter
    # @return [String] default keys delimiter
    def default_key_delimiter
      ','
    end
  end
end
