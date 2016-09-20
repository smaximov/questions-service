# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end
end
