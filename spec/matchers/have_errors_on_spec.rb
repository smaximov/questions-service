# frozen_string_literal: true
# rubocop:disable Style/BlockDelimiters

require 'rails_helper'

RSpec.describe :have_errors_on, type: :matcher do
  let(:model) do
    Class.new do
      include ActiveModel::Model

      attr_accessor :attr1, :attr2

      validates :attr1, presence: true
      validates :attr1, length: 2..4, allow_blank: true

      validates :attr2, presence: true
      validates :attr2, format: /\A\d+\z/

      def self.model_name
        ActiveModel::Name.new(self, nil, 'ModelClass')
      end
    end
  end

  describe 'basic matcher' do
    it 'raises ArgumentError when provided with unknown attribute' do
      object = model.new

      expect {
        expect(object).to have_errors_on(:unkown_attr)
      }.to raise_error(ArgumentError)
    end

    it 'fails on valid attributes' do
      object = model.new(valid_attributes)

      expect {
        expect(object).to have_errors_on(:attr1)
      }.to fail_including('to have errors on :attr1, but it has none')
      expect {
        expect(object).to have_errors_on(:attr2)
      }.to fail_including('to have errors on :attr2, but it has none')
    end

    it 'succeeds on invalid attributes' do
      object = model.new

      expect {
        expect(object).to have_errors_on(:attr1)
        expect(object).to have_errors_on(:attr2)
      }.not_to raise_error
    end
  end

  describe 'chain :only' do
    it 'fails on valid attributes' do
      object = model.new(valid_attributes)

      expect {
        expect(object).to have_errors_on(:attr1).only
      }.to fail_including('to have errors on :attr1 only, but it has none')
      expect {
        expect(object).to have_errors_on(:attr2).only
      }.to fail_including('to have errors on :attr2 only, but it has none')
    end

    it 'fails when multiple attributes are invalid' do
      object = model.new

      expect {
        expect(object).to have_errors_on(:attr1).only
      }.to fail_with(/to have errors on :attr1 only.*errors on other attributes \(:attr2\)/m)
      expect {
        expect(object).to have_errors_on(:attr2).only
      }.to fail_with(/to have errors on :attr2 only.*errors on other attributes \(:attr1\)/m)
    end

    it 'succeeds on a single invalid attribute' do
      object = model.new(attr2: '42')

      expect {
        expect(object).to have_errors_on(:attr1).only
      }.not_to raise_error
    end
  end

  describe 'chain :exactly' do
    it 'fails on valid attributes' do
      object = model.new(valid_attributes)

      expect {
        expect(object).to have_errors_on(:attr1).exactly(1)
      }.to fail_including('to have exactly 1 error(s) on :attr1, but it has 0')
      expect {
        expect(object).to have_errors_on(:attr2).exactly(2)
      }.to fail_including('to have exactly 2 error(s) on :attr2, but it has 0')
    end

    it "fails when the errors count doesn't match the expected value" do
      object = model.new(valid_attributes(attr2: nil))

      expect {
        expect(object).to have_errors_on(:attr2).exactly(1)
      }.to fail_including('to have exactly 1 error(s) on :attr2, but it has 2')
    end

    it 'succeeds when errors count matches the expected value' do
      object = model.new(valid_attributes(attr2: nil))

      expect {
        expect(object).to have_errors_on(:attr2).exactly(2)
      }.not_to raise_error
    end
  end

  describe 'negated matcher' do
    it 'succeeds on valid attributes' do
      object = model.new(valid_attributes)

      expect {
        expect(object).not_to have_errors_on(:attr1)
        expect(object).not_to have_errors_on(:attr2)
      }.not_to raise_error
    end

    it 'fails on an invalid attribute' do
      object = model.new(valid_attributes(attr1: nil))

      expect {
        expect(object).not_to have_errors_on(:attr1)
      }.to fail_including('not to have errors on :attr1')
    end
  end

  describe 'chain :exactly negated' do
    it 'is unsupported' do
      object = model.new

      expect {
        expect(object).not_to have_errors_on(:attr1).exactly(1)
      }.to raise_error(ArgumentError, '#exactly is meant to be used with the positive matcher only')
    end
  end

  describe 'chain :only negated' do
    it 'succeeds when the object has other errors than on the supplied attribute' do
      object = model.new

      expect {
        expect(object).not_to have_errors_on(:attr1).only
      }.not_to raise_error
    end

    it "fails when the observed attribute doesn't have errors" do
      object = model.new(valid_attributes)

      expect {
        expect(object).not_to have_errors_on(:attr1).only
      }.to fail_including(":attr1 doesn't have errors")
    end

    it 'fails when the object has additional errors' do
      object = model.new(valid_attributes(attr1: nil))

      expect {
        expect(object).not_to have_errors_on(:attr1).only
      }.to fail_including('no other errors except on :attr1')
    end
  end

  def valid_attributes(options = {})
    { attr1: 'foo', attr2: '42' }.merge(options)
  end
end
