# frozen_string_literal: true
require 'rails_helper'

class Base
  attr_accessor :attribute
end

RSpec.describe Strippable do
  let(:klass) do
    Class.new(Base) do
      include Strippable

      strip :attribute
    end
  end

  subject { klass.new }

  context 'when argument responds to :strip' do
    it 'strips the argument' do
      subject.attribute = ' foo '
      expect(subject.attribute).to eq('foo')
    end
  end

  context "when argument doesn't respond to :strip" do
    it 'leaves the argument intact' do
      subject.attribute = nil
      expect(subject.attribute).to be_nil
    end
  end
end
