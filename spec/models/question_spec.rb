# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { FactoryGirl.build(:question) }

  it 'has valid factory' do
    expect(question).to be_valid
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
      expect(question).to have_errors_on(:title).only
    end

    it 'is stripped of surrounding whitespace' do
      question.title = " Question Title \n\t"
      expect(question.title).to eq('Question Title')
    end

    it 'has minimun length of 10 characters' do
      question.title = 'a' * 9
      expect(question).to have_errors_on(:title).only
    end

    it 'has maximum length of 50 characters' do
      question.title = 'a' * 51
      expect(question).to have_errors_on(:title).only
    end
  end

  describe '#question' do
    it 'is required' do
      question.question = nil
      expect(question).to have_errors_on(:question).only
    end

    it 'is stripped of surrounding whitespace' do
      question.question = " Question Body \n\t"
      expect(question.question).to eq('Question Body')
    end

    it 'has minimum length of 20 characters' do
      question.question = 'a' * 19
      expect(question).to have_errors_on(:question).only
    end

    it 'has maximum length of 1000 characters' do
      question.question = 'a' * 1001
      expect(question).to have_errors_on(:question).only
    end
  end
end
