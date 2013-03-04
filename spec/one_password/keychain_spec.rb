require 'spec_helper'

describe OnePassword::Keychain do
  KEYCHAIN_DIR = SPEC_ROOT.join('fixtures/1Password.agilekeychain')

  let(:keychain) { OnePassword::Keychain.new(KEYCHAIN_DIR) }
  let(:profile) { keychain.current_profile }

  subject { keychain }
  it { should respond_to(:current_profile) }
  it { should respond_to(:password=) }
  it { should have(1).profiles }

  context '.profile' do
    subject { profile }

    it { should be_a(OnePassword::Profile) }
    it { should respond_to(:all) }
    it { should respond_to(:contents) }
    it { should respond_to(:encryption_keys) }

    its(:contents_file) { should == KEYCHAIN_DIR.join('data/default/contents.js') }
    its(:encryption_keys_file) { should == KEYCHAIN_DIR.join('data/default/encryptionKeys.js') }

    its('all.size') { should == 18 }

    context '.password=' do
      before do
        profile.password = MASTER_PASSWORD
      end

      its('all_encryption_keys.size') { should == 2 }

      context 'all_encryption_keys' do
        it do
          profile.all_encryption_keys.each do |key|
            key.should be_valid
          end
        end
      end

      its(:all) { should be_a(Hash) }
      its(:contents) { should be_a(Hash) }
      its(:name) { should == 'default' }

      PLAIN_PASSWORDS.each do |line|
        context line['title'] do
          let(:item) do
            real_item = nil
            profile.all.each do |id, item|
              real_item = item if item.title == line['title']
            end
            real_item.try(:decrypt_data)
            real_item
          end

          subject { item }

          its(:login_password) { should == line['password'] }
        end if line['title']
      end

      #context 'all' do
      #    context 'webforms.WebForm' do
      #    let(:identifier) { '2A632FDD32F5445E91EB5636C7580447' }
      #    subject(:item) { profile.all[identifier] }
      #
      #    its(:identifier) { should == '2A632FDD32F5445E91EB5636C7580447' }
      #  #  before { item.decrypt_data }
      #  #
      #  #  it { should be_a(OnePassword::Item) }
      #  #  its(:username) { should == 'WendyAppleseed' }
      #  #  its(:password) { should == 'dej3ur9unsh5ian1and5' }
      #  end
      #end
    end
  end
end
