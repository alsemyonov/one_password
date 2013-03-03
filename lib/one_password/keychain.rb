# coding: utf-8

require 'json'
require 'one_password/profile'
require 'one_password/errors'

module OnePassword
  class Keychain
    def initialize(directory = '~/Dropbox/1Password.agilekeychain')
      @directory       = Pathname(File.expand_path(directory))
      @master_password = nil
      profiles
    end

    # @return [Profile]
    def current_profile
      @current_profile ||= profiles['default']
    end

    # @param [String, Profile] profile
    def current_profile=(profile)
      unless profile.is_a?(Profile)
        raise UndefinedProfile.new(profile) unless profiles.key?(profile)
        profile = profiles[profile]
      end
      @profile = profile
    end

    protected

    def data_directory
      @directory.join('data')
    end

    def profiles
      @profiles ||= Dir["#{data_directory}/*"].inject({}) do |result, dir|
        profile              = Profile.new(self, dir)
        result[profile.name] = profile
        result
      end
    end
  end
end
