# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { FactoryGirl.build(:question) }

  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to have_many(:answers) }

  it 'has valid factory' do
    expect(question).to be_valid
  end

  describe 'default scope' do
    it 'is descending on :created_at' do
      question.save
      # Create another question before the question was created
      other_question = Timecop.freeze(1.day.ago) { FactoryGirl.create(:question) }
      expect(Question.pluck(:id)).to eq([question.id, other_question.id])
    end
  end

  describe '#author' do
    it 'is valid' do
      expect(question.author).to be_valid
    end

    it 'is a belongs_to association' do
      assoc_type = Question.reflect_on_association(:author).macro
      expect(assoc_type).to be(:belongs_to)
    end
  end

  describe '#title' do
    it 'is required' do
      question.title = nil
      expect(question).to have_errors_on(:title).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      question.title = ''
      expect(question).to have_errors_on(:title).only.exactly(1).message(:blank)
    end

    it 'is stripped of surrounding whitespace' do
      question.title = " Question Title \n\t"
      expect(question.title).to eq('Question Title')
    end

    it 'is at least 10 characters' do
      question.title = 'a' * 9
      expect(question).to have_errors_on(:title).only.exactly(1).message(:too_short, count: 10)
    end

    it 'is at most 200 characters' do
      question.title = 'a' * 201
      expect(question).to have_errors_on(:title).only.exactly(1).message(:too_long, count: 200)
    end
  end

  describe '#question' do
    it 'is required' do
      question.question = nil
      expect(question).to have_errors_on(:question).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      question.question = ''
      expect(question).to have_errors_on(:question).only.exactly(1).message(:blank)
    end

    it 'is stripped of surrounding whitespace' do
      question.question = " Question Body \n\t"
      expect(question.question).to eq('Question Body')
    end

    it 'is at least 20 characters' do
      question.question = 'a' * 19
      expect(question).to have_errors_on(:question).only.exactly(1).message(:too_short, count: 20)
    end

    it 'is at most 5000 characters' do
      question.question = 'a' * 5001
      expect(question).to have_errors_on(:question).only.exactly(1).message(:too_long, count: 5000)
    end
  end
end
