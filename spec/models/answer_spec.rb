# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { FactoryGirl.build(:answer) }

  it 'has valid factory' do
    expect(answer).to be_valid
  end

  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to belong_to(:question) }

  describe 'default scope' do
    it 'is descending on :created_at' do
      answer.save
      # Create another answer before the answer was created
      other_answer = Timecop.freeze(1.day.ago) { FactoryGirl.create(:answer) }
      expect(Answer.pluck(:id)).to eq([answer.id, other_answer.id])
    end
  end

  describe '#answer' do
    it 'is required' do
      answer.answer = nil
      expect(answer).to have_errors_on(:answer).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      answer.answer = ''
      expect(answer).to have_errors_on(:answer).only.exactly(1).message(:blank)
    end

    it 'is at least 20 characters' do
      answer.answer = 'a' * 19
      expect(answer).to have_errors_on(:answer).only.exactly(1).message(:too_short, count: 20)
    end

    it 'is at most 5000 characters' do
      answer.answer = 'a' * 5001
      expect(answer).to have_errors_on(:answer).only.exactly(1).message(:too_long, count: 5000)
    end

    it 'is stripped of surrounding whitespace' do
      answer.answer = " Answer Body \n\t"
      expect(answer.answer).to eq('Answer Body')
    end
  end
end
