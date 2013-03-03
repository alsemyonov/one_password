require 'one_password/encryption'

module OnePassword
  class Item
    INDEX_UUID              = 0
    INDEX_TYPE              = 1
    INDEX_NAME              = 2
    INDEX_URL               = 3
    INDEX_DATE              = 4
    INDEX_FOLDER            = 5
    INDEX_PASSWORD_STRENGTH = 6
    INDEX_TRASHED           = 7

    # @return [String]
    attr_reader :uuid
    attr_reader :type
    attr_reader :title
    attr_reader :domain
    # @return [Time]
    attr_reader :updated_at

    # @return [OnePassword::Profile]
    attr_reader :profile

    # @param [Profile] profile
    # @param [Array] data
    def initialize(profile, data)
      @profile    = profile
      @uuid       = data[INDEX_UUID]
      @type       = data[INDEX_TYPE]
      @title      = data[INDEX_NAME]
      @domain     = data[INDEX_URL]
      @updated_at = Time.at(data[INDEX_DATE])
      @trashed    = data[INDEX_TRASHED]
    end

    def system?
      @type =~ /^system/
    end

    def wallet?
      @type =~ /^wallet\.(membership|financial|government)}/
    end

    def trashed?
      @trashed == 'Y'
    end

    def category
      @category ||= case type
                    when SOFTWARE_LICENSES, WEBFORMS, NOTES, IDENTITIES, PASSWORDS
                      type.to_sym
                    else
                      if type == FOLDERS
                        :folders
                      elsif wallet?
                        WALLET
                      else
                        ACCOUNT.to_sym
                      end
                    end
    end

    def matches?(text)
      title.downcase.index(text) || domain.downcase.index(text)
    end

    def file_name
      profile.directory.join("#{uuid}.1password")
    end

    def security_level
      @security_level || 'SL5'
    end

    def encryption_key
      profile.encryption_keys[security_level].decrypted_key
    end

    def load_encrypted_data
      self.attributes = JSON.parse(File.read(file_name))
    end

    def encrypted
      load_encrypted_data unless @encrypted
      @encrypted
    end

    def decrypt_data
      plain_text = Encryption.decrypt_using_key(encrypted, encryption_key)

      require 'cgi'

      self.attributes = JSON.parse(plain_text)
    end

    def attributes
      instance_variables.inject({}) do |result, ivar|
        result[ivar] = instance_variable_get(ivar) unless ivar == :@profile
        result
      end
    end

    def attributes=(attrs)
      attrs.each do |name, value|
        send("#{name}=", value)
      end
    end

    def method_missing(method, *args, &block)
      if method =~ /=\Z/
        instance_variable_set("@#{method[0..-2]}", args.first)
      elsif args.empty? && instance_variable_defined?((ivar_name = :"@#{method}"))
        instance_variable_get(ivar_name)
      else
        super
      end
    end
  end
end
