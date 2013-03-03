require 'one_password/encryption_key'
require 'one_password/item'

module OnePassword
  class Profile
    # @param [OnePassword::Keychain] keychain
    # @param [String, Pathname] directory
    def initialize(keychain, directory)
      @keychain  = keychain
      @name      = File.basename(directory)
      @directory = Pathname(directory)
    end

    attr_reader :name, :encryption_keys, :directory, :password

    def contents
      load_contents unless @contents
      @contents
    end

    def all
      load_contents unless @all
      @all
    end

    def encryption_keys
      load_encryption_keys unless @encryption_keys
      @encryption_keys
    end

    def encryption_keys_loaded?
      !!@encryption_keys
    end

    def password=(password)
      @password = password
    end

    protected

    def contents_file
      @directory.join('contents.js')
    end

    def encryption_keys_file
      @directory.join('encryptionKeys.js')
    end

    def load_encryption_keys
      self.encryption_keys = JSON.parse(File.read(encryption_keys_file))
    end

    def load_contents
      self.contents = JSON.parse(File.read(contents_file)) unless @contents
    end

    # @param [Array] new_contents
    def contents=(new_contents)
      @all      = {}
      @contents = CATEGORIES.inject({}) do |result, type|
        result[type] = []
        result
      end

      new_contents.each do |item_array|
        item = Item.new(self, item_array)
        next if item.system?

        @all[item.uuid] = item
        @contents[item.category] << item
      end

      @contents
    end

    def encryption_keys=(keys)
      @all_encryption_keys = keys.delete('list').map { |data| EncryptionKey.new(self, data) }
      @encryption_keys     = keys.inject({}) do |result, (type, identifier)|
        result[type] = @all_encryption_keys.find { |key| key.identifier == identifier }
        result
      end
    end
    attr_accessor :all_encryption_keys
  end
end
