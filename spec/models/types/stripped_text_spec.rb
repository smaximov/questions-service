# frozen_string_literal: true
require 'rails_helper'

RSpec.describe StrippedText, type: :type do
  describe '#cast' do
    it 'strips surrounding whitespace from strings' do
      expect(subject.cast("\v\r foo \n\t")).to eq('foo')
    end

    it 'accepts nil' do
      expect(subject.cast(nil)).to eq(nil)
    end

    it 'converts values of other types to string' do
      expect(subject.cast(42)).to eq('42')
    end
  end
end
