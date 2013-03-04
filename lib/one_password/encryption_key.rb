require 'one_password/encryption'

module OnePassword
  class EncryptionKey
    #noinspection RubyResolve
    attr_accessor :profile, :data, :validation, :level, :iterations, :identifier

    def initialize(profile, data)
      @profile = profile
      data.each do |name, value|
        send("#{name}=", value)
      end
    end

    #noinspection RubyResolve
    def iterations=(iterations)
      @iterations = iterations.to_i
      @iterations = 1000 if @iterations < 1000
      @iterations
    end

    def decrypt(password=self.profile.password)
      @decrypted_key = Encryption.decrypt_using_pbkdf2(data, password, iterations)
    end

    def decrypted_key
      @decrypted_key || decrypt
    end

    def valid?
      Encryption.decrypt_using_key(validation, decrypted_key) == decrypted_key
    end
  end
end
