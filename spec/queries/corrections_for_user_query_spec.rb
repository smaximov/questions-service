# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CorrectionsForUserQuery, type: :query do
  let(:answer_author) { FactoryGirl.create(:confirmed_user) }
  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:other_user) { FactoryGirl.create(:confirmed_user) }
  let(:answer) { FactoryGirl.create(:answer, author: answer_author) }

  before do
    correction = answer.corrections.create!(text: "Answer's correction text",
                                            author: answer_author)
    correction.accept(AcceptCorrectionForm.from_correction(correction))

    answer.corrections.create!(text: "Answer's correction text",
                               author: user)

    answer.corrections.create!(text: "Answer's correction text",
                               author: other_user)
    answer.corrections.create!(text: "Answer's correction text",
                               author: other_user, accepted_at: Time.current)
  end

  describe 'query results' do
    context 'when viewn by unauthenticated user' do
      it 'returns only accepted corrections' do
        query = CorrectionsForUserQuery.new(nil)
        expect(query.results(answer).count).to eq(2)
      end
    end

    context "when viewn by the answer's author" do
      it 'returns all corrections' do
        query = CorrectionsForUserQuery.new(answer_author)
        expect(query.results(answer).count).to eq(4)
      end
    end

    context 'when viewn by some other user' do
      it 'returns accepted corrections and corrections made by that user' do
        query = CorrectionsForUserQuery.new(other_user)
        expect(query.results(answer).count).to eq(3)
      end
    end
  end
end
