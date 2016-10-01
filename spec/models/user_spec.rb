# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it 'has valid factory' do
    expect(user).to be_valid
  end

  it { is_expected.to have_many(:questions).foreign_key(:author_id) }
  it { is_expected.to have_many(:answers).foreign_key(:author_id) }

  describe '#errors' do
    before { subject.save }

    it 'is displayed in the particular order' do
      expect(subject.errors.keys).to eq(%i(username fullname email password))
    end
  end

  describe '#username' do
    it 'is required' do
      user.username = nil
      expect(user).to have_errors_on(:username).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      user.username = ''
      expect(user).to have_errors_on(:username).only.exactly(1).message(:blank)
    end

    it 'is unique' do
      FactoryGirl.create(:user, username: user.username)
      expect(user).to have_errors_on(:username).only.exactly(1).message(:taken)
    end

    it 'contains only valid letters' do
      user.username = 'john doe'
      expect(user).to have_errors_on(:username).only.exactly(1).message(:invalid)
    end

    it 'has minimum length of 3' do
      user.username = 'jd'
      expect(user).to have_errors_on(:username).only.exactly(1).message(:too_short, count: 3)
    end

    it 'has maximum length of 20' do
      user.username = 'a' * 21
      expect(user).to have_errors_on(:username).only.exactly(1).message(:too_long, count: 20)
    end

    it 'is stripped of surrounding whitespace' do
      user.username = " john.doe \n\t"
      expect(user.username).to eq('john.doe')
    end
  end

  describe '#fullname' do
    it 'is required' do
      user.fullname = nil
      expect(user).to have_errors_on(:fullname).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      user.fullname = ''
      expect(user).to have_errors_on(:fullname).only.exactly(1).message(:blank)
    end

    it 'has minimum length of 5' do
      user.fullname = 'a' * 4
      expect(user).to have_errors_on(:fullname).only.exactly(1).message(:too_short, count: 5)
    end

    it 'has maximum length of 30' do
      user.fullname = 'a' * 31
      expect(user).to have_errors_on(:fullname).only.exactly(1).message(:too_long, count: 30)
    end

    it 'is stripped of surrounded whitespace' do
      user.fullname = " John Doe \n\t"
      expect(user.fullname).to eq('John Doe')
    end
  end

  describe '#login' do
    it 'is stripped of surrounding whitespace' do
      user.login = " john.doe \n\t"
      expect(user.login).to eq('john.doe')
    end
  end
end
