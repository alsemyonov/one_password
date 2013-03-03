require 'one_password/version'

module OnePassword
  WEBFORMS              = 'webforms.WebForm'
  FOLDERS               = 'system.folder.Regular'
  NOTES                 = 'securenotes.SecureNote'
  IDENTITIES            = 'identities.Identity'
  PASSWORDS             = 'passwords.Password'
  WALLET                = 'wallet'
  SOFTWARE_LICENSES     = 'wallet.computer.License'
  TRASHED               = 'trashed'
  ACCOUNT               = 'account'
  ACCOUNT_ONLINESERVICE = 'wallet.onlineservices.'
  ACCOUNT_COMPUTER      = 'wallet.computer.'
  CATEGORIES            = [WEBFORMS, NOTES, WALLET, PASSWORDS, IDENTITIES, SOFTWARE_LICENSES, :folders,
                           ACCOUNT, TRASHED,].map { |type| type.to_sym }
end

require 'one_password/keychain'
