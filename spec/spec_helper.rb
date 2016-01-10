require 'rspec'
require 'rspec/its'

require 'one_password'
require 'csv'

SPEC_ROOT = Pathname.new(File.dirname(__FILE__))
PLAIN_PASSWORDS = CSV.read(SPEC_ROOT.join('fixtures/1Password.tsv'), col_sep: "\t", headers: :first_col)
MASTER_PASSWORD = '1Password'

#noinspection RubyResolve
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

