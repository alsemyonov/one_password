require 'spec_helper'

describe OnePassword::Keychain do
  subject(:keychain) { OnePassword::Keychain.new(SPEC_ROOT.join('fixtures/1Password.agilekeychain')) }
  let(:profile) { keychain.current_profile }

  it { should respond_to(:current_profile) }
  it { should respond_to(:password=) }

  describe '.profile' do
    subject { profile }

    it { should respond_to(:all) }
    it { should respond_to(:contents) }
    it { should respond_to(:encryption_keys) }

    its('all.size') { should == 18 }

    context ''
  end
end
