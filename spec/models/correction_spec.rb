# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Correction, type: :model do
  let(:correction) { FactoryGirl.build(:correction) }

  it 'has valid factory' do
    expect(correction).to be_valid
  end

  it { is_expected.to belong_to(:author).class_name(::User) }
  it { is_expected.to belong_to(:answer) }
  it { is_expected.to belong_to(:answer_version).class_name(::Answer::Version).optional(true) }

  describe '#text' do
    it 'is required' do
      correction.text = nil
      expect(correction).to have_errors_on(:text).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      correction.text = ''
      expect(correction).to have_errors_on(:text).only.exactly(1).message(:blank)
    end

    it 'is at least 20 characters long' do
      correction.text = 'a' * 19
      expect(correction).to have_errors_on(:text).only.exactly(1).message(:too_short, count: 20)
    end

    it 'is at most 500 characters long' do
      correction.text = 'a' * 501
      expect(correction).to have_errors_on(:text).only.exactly(1).message(:too_long, count: 500)
    end
  end

  describe '#text=' do
    it 'strips surrounding whitespace' do
      correction.text = "  foobar \n\t"
      expect(correction.text).to eq('foobar')
    end

    it 'squishes consecutive whitespace' do
      correction.text = "foo \n\v\t bar"
      expect(correction.text).to eq('foo bar')
    end
  end
end
