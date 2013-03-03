require 'base64'
require 'openssl'
require 'pbkdf2'
require 'cgi'

module OnePassword
  class Encryption
    ZERO_IV = "\x00" * 8
    NR      = 10
    NK      = 4

    def self.decrypt_using_pbkdf2(data, password, iterations)
      encrypted = Base64.decode64(data)
      salt      = ZERO_IV
      if salted?(encrypted)
        salt      = encrypted[8, 8]
        encrypted = encrypted[16..-1]
      end

      derived_key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, salt, iterations, 32)

      key = derived_key.slice(0..15)
      iv  = derived_key.slice(16..-1)

      decrypt_using_key_and_ivec(encrypted, key, iv)
    end

    def self.decrypt_using_key(encrypted, encryption_key)
      encrypted = Base64.decode64(encrypted)

      if Encryption.salted?(encrypted)
        salt      = encrypted[8, 8]
        encrypted = encrypted[16..-1]

        key, iv = Encryption.open_ssl_key(encryption_key, salt)
      else
        key = OpenSSL::Digest::MD5.digest(encryption_key)
        iv  = Encryption::ZERO_IV
      end

      plain_text = Encryption.decrypt_using_key_and_ivec(encrypted, key, iv)


      CGI::unescape(CGI::escape(plain_text))

    end

    def self.decrypt_using_key_and_ivec(encrypted, key, iv)
      aes = OpenSSL::Cipher.new('AES-128-CBC')
      aes.decrypt
      aes.key = key
      aes.iv  = iv
      aes.update(encrypted) << aes.final
    end

    def self.salted?(string)
      (string =~ /\ASalted__/)
    end

    def self.open_ssl_key(password, salt)
      rounds   = NR >= 12 ? 3 : 2
      data00   = password + salt
      md5_hash = [OpenSSL::Digest::MD5.digest(data00)]
      result   = md5_hash[0]
      1.upto(rounds - 1) do |i|
        md5_hash[i] = OpenSSL::Digest::MD5.digest(md5_hash[i - 1] + data00)
        result      += md5_hash[i]
      end
      key = result.slice(0..(4 * NK - 1))
      iv  = result.slice((4 * NK)..(4 * NK + 15))
      [key, iv]
    end
  end
end
