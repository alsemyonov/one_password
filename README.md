# OnePassword

Decryptor for 1Password Agile Keychain.
It could decrypt passwords, stored in keychain, using your master password and PBKDF2-based encryption keys, stored in
Agile Keychain.

## Links

### Released

* [RubyGem](https://rubygems.org/gems/one_password)
* [Documentation](http://rubydoc.info/gems/one_password/frames)

### WIP

* [Github](https://github.com/alsemyonov/one_password)
* [Documentation](http://rubydoc.info/github/alsemyonov/one_password/frames)
* [![Build Status](https://travis-ci.org/alsemyonov/one_password.png?branch=master)](https://travis-ci.org/alsemyonov/one_password)
* [![Code Climate](https://codeclimate.com/github/alsemyonov/one_password.png)](https://codeclimate.com/github/alsemyonov/one_password)

## Installation

Add this line to your application's Gemfile:

    gem 'one_password'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install one_password

## Usage

```ruby

keychain = OnePassword::Keychain.new('~/Dropbox/1Password.agilekeychain')

keychain.password = '1Password'

keychain.all.first[1].login_username
keychain.all.first[1].login_password

```

## TODO

* Different types of items
* Encrypting and storing new passwords
* Simple sinatr interface for showing and modifying keychain

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
