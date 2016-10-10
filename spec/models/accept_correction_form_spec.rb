# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AcceptCorrectionForm, type: :model do
  describe '#test' do
    it 'is required' do
      subject.text = nil
      expect(subject).to have_errors_on(:text).only.exactly(1).message(:blank)
    end

    it 'is non-blank' do
      subject.text = ''
      expect(subject).to have_errors_on(:text).only.exactly(1).message(:blank)
    end

    it 'is at least 20 characters long' do
      subject.text = 'a' * 19
      expect(subject).to have_errors_on(:text).only.exactly(1).message(:too_short, count: 20)
    end

    it 'is at most 5000 characters long' do
      subject.text = 'a' * 5001
      expect(subject).to have_errors_on(:text).only.exactly(1).message(:too_long, count: 5000)
    end

    it 'is stripped of surrounding whitespace' do
      subject.text = "  foobar \n\t"
      expect(subject.text).to eq('foobar')
    end
  end
end
