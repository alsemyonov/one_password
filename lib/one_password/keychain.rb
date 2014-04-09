# coding: utf-8

require 'json'
require 'one_password/profile'
require 'one_password/errors'
require 'pathname'

module OnePassword
  class Keychain
    def initialize(directory = '~/Dropbox/1Password.agilekeychain')
      @directory       = Pathname(File.expand_path(directory))
      @master_password = nil
      @profiles = profiles
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

    def password=(password)
      current_profile.password = password
    end

    protected

    def data_directory
      @directory.join('data')
    end

    def profiles
      profile_list = {}

      Dir["#{data_directory}/*"].each do |dir|
        profile              = Profile.new(self, dir)
        profile_list[profile.name] = profile
      end

      profile_list
    end
  end
end
