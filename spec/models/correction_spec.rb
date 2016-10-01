# frozen_string_literal: true
require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe Correction, type: :model do
  let(:correction) { FactoryGirl.build(:correction) }

  it 'has valid factory' do
    expect(correction).to be_valid
  end

  it { is_expected.to belong_to(:author).class_name('User') }
  it { is_expected.to belong_to(:answer) }

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

    it 'is stripped of surrounding whitespace' do
      correction.text = "  foo bar \n\t"
      expect(correction.text).to eq('foo bar')
    end
  end

  describe '#accepted_at' do
    context "when correction's author doesn't match the answer's author" do
      it 'is not set after creation' do
        correction.save!
        expect(correction.reload.accepted_at).to be_nil
      end
    end

    context "when correction's author is the answer's author" do
      it 'is set to the current time after creation' do
        correction.author = correction.answer.author
        travel_to(Time.current) do
          correction.save!
          expect(correction.reload.accepted_at).to eq(Time.current)
        end
      end

      it "doesn't change on subsequent saves after creation" do
        correction.author = correction.answer.author
        correction.save!

        expect(correction.accepted_at).not_to be_nil
        expect {
          travel_to(1.minute.from_now) do
            correction.text += ' updated'
            correction.save!
          end
        }.to change { correction.updated_at } & not_change { correction.accepted_at }
      end
    end
  end
end
