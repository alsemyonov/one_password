require 'one_password'

SPEC_ROOT = Pathname.new(File.dirname(__FILE__))

#noinspection RubyResolve
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
