# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    xit { is_expected.not_to allow_value('test@example').for(:email) }
    it { is_expected.not_to allow_value('testexample.com').for(:email) }

    context 'when existing email is used for a new user' do
      it 'raises validation error' do
        user = create(:user)
        new_user = build(:user, email: user.email)
        expect(new_user).to be_invalid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:events).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe '#clean_and_sanitize_fields' do
      let(:user) { build(:user, first_name: ' John ', last_name: ' Doe ', email: ' JOHN@EXAMPLE.COM ') }

      it 'strips leading and trailing whitespace from first_name and last_name' do
        user.save
        expect(user.first_name).to eq('John')
        expect(user.last_name).to eq('Doe')
      end

      it 'strips leading and trailing whitespace and downcases email' do
        user.save
        expect(user.email).to eq('john@example.com')
      end
    end
  end
end
