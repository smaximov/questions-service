# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { FactoryGirl.build(:answer) }

  it 'has valid factory' do
    expect(answer).to be_valid
  end

  it { is_expected.to belong_to(:author).class_name(::User) }
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_many(:corrections) }
  it { is_expected.to belong_to(:current_version).class_name(::Answer::Version) }

  describe 'default scope' do
    it 'is descending on :created_at' do
      answer.save
      # Create another answer before the answer was created
      other_answer = travel_to(1.day.ago) { FactoryGirl.create(:answer) }
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

  describe '#page' do
    let(:extra_answers) { 0 }
    let(:question) { FactoryGirl.create(:question) }

    before do
      answer.question = question
      answer.save

      travel_to(1.day.from_now) do
        FactoryGirl.create_list(:answer, extra_answers, question: question)
      end
    end

    context 'with less than 15 answers' do
      it 'equals 1' do
        expect(answer.page).to eq(1)
      end
    end

    context 'with 15 answers' do
      let(:extra_answers) { 14 }

      it 'equals 1' do
        expect(answer.page).to eq(1)
      end
    end

    context 'with 16 answers' do
      let(:extra_answers) { 15 }

      it 'equals 2' do
        expect(answer.page).to eq(2)
      end
    end

    context 'with additional answers to the other question' do
      let(:other_question) { FactoryGirl.create(:question) }
      let(:extra_answers) { 14 }

      before do
        travel_to(2.days.from_now) do
          FactoryGirl.create_list(:answer, extra_answers, question: other_question)
        end
      end

      it 'equals 1' do
        expect(answer.page).to eq(1)
      end
    end
  end

  describe '#mark_as_best' do
    it 'marks the answer as the best answer to the corresponding question' do
      expect(answer.question.best_answer).to be_nil
      answer.mark_as_best
      expect(answer.question.best_answer).to be(answer)
    end
  end

  describe '#best?' do
    context 'when the answer is not marked as the best' do
      it 'is false' do
        expect(answer).not_to be_best
      end
    end

    context 'when the answer is marked as the best' do
      before { answer.mark_as_best }

      it 'is true' do
        expect(answer).to be_best
      end
    end
  end

  describe '#pending_corrections_count' do
    before { answer.save! }

    context 'when the newly created correction is accepted' do
      it "doesn't change" do
        expect {
          FactoryGirl.create(:correction, answer: answer, accepted_at: Time.current)
        }.not_to change { answer.reload.pending_corrections_count }
      end
    end

    context 'when the newly created correction is not yet accepted' do
      it 'changes by 1' do
        expect {
          FactoryGirl.create(:correction, answer: answer)
        }.to change { answer.reload.pending_corrections_count }.by(1)
      end
    end
  end

  describe '#accepted_corrections_count' do
    before { answer.save! }

    context 'when the newly created correction is accepted' do
      it 'changes by 1' do
        expect {
          FactoryGirl.create(:correction, answer: answer, accepted_at: Time.current)
        }.to change { answer.reload.accepted_corrections_count }.by(1)
      end
    end

    context 'when the newly created correction is not yet accepted' do
      it "doesnt' change" do
        expect {
          FactoryGirl.create(:correction, answer: answer)
        }.not_to change { answer.reload.accepted_corrections_count }
      end
    end
  end

  describe Answer::Version do
    context 'when a new Answer record is saved' do
      it 'is created' do
        expect {
          answer.save!
        }.to change { Answer::Version.count }.by(1)
      end
    end
  end
end
