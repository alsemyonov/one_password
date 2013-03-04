require 'one_password/encryption'
require 'active_support/core_ext'

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
    attr_accessor :uuid, :type, :title, :domain, :updated_at, :trashed, :security_level, :open_contents, :encrypted#,
                  #:location_key, :open_contents, :key_id, :location, :encrypted,
                  #:created_at, :trashed, :type_name #,
                                                    #:reminderq, :port, :notes_plain, :cash_limit, :html_name, :fields,
                                                    #:expiry_mm, :expiry_yy, :member_name, :zip, :database_type, :html_action, :phone_toll_free,
                                                    #:lastname, :password, :html_method, :html_id,
                                                    #:renewal_date_yy, :renewal_date_mm, :renewal_date_dd, :cardholder, :credit_limit,
                                                    #:birthdate_yy, :birthdate_mm, :birthdate_dd, :username, :company, :bank, :email, :ccnum,
                                                    #:idisk_storage, :pin, :firstname, :path, :hostname, :website, :country, :interest, :database, :sex,
                                                    #:server, :cvv, :address1, :address2, :cellphone_local, :city, :aim, :jobtitle, :state, :occupation,
                                                    #:department, :busphone_local
                                                    # @return [Time]

    # @return [OnePassword::Profile]
    attr_reader :profile

    # @param [Profile] profile
    # @param [Array] data
    def initialize(profile, data)
      @profile        = profile
      self.attributes = {
        uuid:       data[INDEX_UUID],
        type:       data[INDEX_TYPE],
        title:      data[INDEX_NAME],
        domain:     data[INDEX_URL],
        updated_at: data[INDEX_DATE],
        trashed:    data[INDEX_TRASHED]
      }
    end

    def updated_at=(seconds)
      @updated_at = Time.at(seconds)
    end

    def created_at=(seconds)
      @created_at = Time.at(seconds)
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
      open_contents.try(:[], 'securityLevel') || 'SL5'
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
      unless @decrypted
        @decrypted      = true
        plain_text = Encryption.decrypt_using_key(encrypted, encryption_key)
        attrs = JSON.parse(plain_text)
        self.attributes = attrs
      end
    end

    def login_username
      find_field_with_designation('username')
    end

    def login_password
      attributes['password'].presence || find_field_with_designation('password')
    end

    def find_field_with_designation(designation)
      fields = attributes['fields']
      field = fields.find do |field|
        field['designation'] == designation
      end if fields

      field['value'] if field
    end

    def attributes
      @attributes ||= {}
      fields = instance_variables.inject({}) do |result, ivar|
        result[ivar] = instance_variable_get(ivar) unless ivar == :@profile
        result
      end
      @attributes.merge(fields)
    end

    def attributes=(attrs)
      attrs.each do |name, value|
        if value.present?
          attribute = name.to_s.underscore
          writer    = "#{attribute}="
          if respond_to?(writer)
            send(writer, value)
          else
            @attributes            ||= {}
            @attributes[attribute] = value
          end
        end
      end
    end
  end
end
