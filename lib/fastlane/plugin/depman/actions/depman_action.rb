require 'fastlane/action'
require_relative '../helper/depman_helper'

module Fastlane
  module Actions
    class DepmanAction < Action
      def self.run(params)
        verify_depman_scanner_binary

        command_prefix = [
          'cd',
          File.expand_path('.').shellescape,
          '&&'
        ].join(' ')

        depman_scanner_args = []
        depman_scanner_args << "--src=\"#{params[:project_root]}\"" if params[:project_root]
        depman_scanner_args << "--host=\"#{params[:server_host]}\"" if params[:server_host]
        depman_scanner_args << "--token=\"#{params[:auth_token]}\"" if params[:auth_token]
        depman_scanner_args << "--name=\"#{params[:project_name]}\"" if params[:project_name]
        depman_scanner_args << "--version=\"#{params[:project_version]}\"" if params[:project_version]
        depman_scanner_args << "--platform=\"#{params[:project_platform]}\"" if params[:project_platform]
		   
        command = [
          command_prefix,
          'depman-scanner',
          depman_scanner_args
        ].join(' ')
        # hide command, as it may contain credentials
        Fastlane::Actions.sh_control_output(command, print_command: false, print_command_output: true)
      end

      def self.verify_depman_scanner_binary
        UI.user_error!("You have to install depman-scanner") unless `which depman-scanner`.to_s.length > 0
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Arcsinus Dependency manager"
      end

      def self.details
        "Invokes depman-scanner to programmatically run Depman analysis"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project_root,
                                        env_name: "FL_DEPMAN_PROJECT_ROOT",
                                        description: "The path to your project",
                                        optional: false,
                                        verify_block: proc do |value|
                                          UI.user_error!("Couldn't find file at path '#{value}'") unless value.nil? || File.exist?(value)
                                        end),
          FastlaneCore::ConfigItem.new(key: :server_host,
                                       env_name: "FL_DEPMAN_SERVER_HOST",
                                       description: "",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :auth_token,
                                       env_name: "FL_DEPMAN_AUTH_TOKEN",
                                       description: "",
                                       optional: true,
                                       is_string: true,
                                       sensitive: true),
          FastlaneCore::ConfigItem.new(key: :project_name,
                                       env_name: "FL_DEPMAN_PROJECT_NAME",
                                       description: "",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :project_version,
                                       env_name: "FL_DEPMAN_PROJECT_VERSION",
                                       description: "",
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :project_platform,
                                       env_name: "FL_DEPMAN_PROJECT_PLATFORM",
                                       description: "",
                                       optional: true,
                                       is_string: true),
        ]
      end

      def self.return_value
        "The exit code of the depman-scanner binary"
      end

      def self.authors
        ["shapovalov@arcsinus.ru"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'depman(
            project_root: File.expand_path("../MyProject"),
            server_host: "depman.company.org",
            auth_token: "1234567890abcdef",
            project_name: "my-project",
            project_version: "1.0",
            project_platform: "gradle"
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end
