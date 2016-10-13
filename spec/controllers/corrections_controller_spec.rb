# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CorrectionsController, type: :controller do
  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:answer) { FactoryGirl.create(:answer) }

  describe 'GET #new' do
    def perform_request
      get(:new, params: { id: answer.id }, xhr: true)
    end

    context 'when the user is not signed in' do
      it 'is unauthorized' do
        perform_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in' do
      before { sign_in user }

      it 'is successfull' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    let(:correction) { FactoryGirl.build(:correction, answer: answer) }

    def perform_request
      params = { id: answer.id, correction: { text: correction.text } }
      post(:create, params: params, xhr: true)
    end

    context 'when the user is not signed in' do
      it 'is unauthorized' do
        perform_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the user is signed in' do
      before { sign_in user }

      it 'is successfull' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #accepting' do
    let(:correction) { FactoryGirl.create(:correction) }

    def perform_request
      get(:accepting, params: { id: correction.id }, xhr: true)
    end

    context 'when the user is not signed in' do
      it 'is unauthorized' do
        perform_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when signed in as wrong user' do
      before { sign_in user }

      it 'is unauthorized' do
        perform_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when signed in as the answer's author" do
      before { sign_in correction.answer.author }

      it 'is successfull' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #accept' do
    let(:correction) { FactoryGirl.create(:correction) }
    let(:accept_correction_form) { AcceptCorrectionForm.from_correction(correction) }

    def perform_request
      params = { id: correction.id, accept_correction_form: { text: accept_correction_form.text } }
      post(:accept, params: params, xhr: true)
    end

    context 'when the user is not signed in' do
      it 'is unauthorized' do
        perform_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when signed in as wrong user' do
      it { sign_in user }

      it 'is unauthorized' do
        perform_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when signed in as the answer's author" do
      before { sign_in correction.answer.author }

      it 'is successfull' do
        perform_request
        expect(response).to have_http_status(:success)
      end
    end
  end
end
