# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  describe '#username' do
    it 'is required' do
      user.username = nil
      user.valid?
      expect(user.errors[:username].size).to eq(1)
    end

    it 'is unique' do
      FactoryGirl.create(:user, username: user.username)
      user.valid?
      expect(user.errors[:username].size).to eq(1)
    end

    it 'contains only valid letters' do
      user.username = 'john doe'
      user.valid?
      expect(user.errors[:username].size).to eq(1)
    end

    it 'has minimum length of 3' do
      user.username = 'jd'
      user.valid?
      expect(user.errors[:username].size).to eq(1)
    end

    it 'has maximum length of 20' do
      user.username = 'a' * 21
      user.valid?
      expect(user.errors[:username].size).to eq(1)
    end
  end

  describe '#fullname' do
    it 'is required' do
      user.fullname = nil
      user.valid?
      expect(user.errors[:fullname].size).to eq(1)
    end

    it 'has minimum length of 5' do
      user.fullname = 'a' * 4
      user.valid?
      expect(user.errors[:fullname].size).to eq(1)
    end

    it 'has maximum length of 30' do
      user.fullname = 'a' * 31
      user.valid?
      expect(user.errors[:fullname].size).to eq(1)
    end

    it 'is stripped of surrounded whitespace' do
      user.fullname = " John Doe \n\t"
      expect(user.fullname).to eq('John Doe')
    end
  end
end
