# frozen_string_literal: true
require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { FactoryGirl.create(:confirmed_user) }

  describe 'GET #new' do
    context 'when user is signed out' do
      it 'redirects to the sign in page' do
        get :new
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end

    context 'when user is signed in' do
      before { sign_in user }

      it 'is successfull' do
        get :new
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #mark_as_best' do
    context 'when the user is signed out' do
      it 'redirects to the sign in page' do
        post :mark_as_best, params: { id: 42 }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe 'DELETE #cancel_best' do
    context 'when the user is signed out' do
      it 'redirects to the sign in page' do
        post :cancel_best, params: { id: 42 }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
      end
    end
  end

  describe 'GET #suggest_correction' do
    let(:answer) { FactoryGirl.create(:answer) }

    def perform_request
      get(:suggest_correction, params: { id: answer.id }, xhr: true)
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

  describe 'POST #create_correction' do
    let(:answer) { FactoryGirl.create(:answer) }
    let(:correction) { FactoryGirl.build(:correction, answer: answer) }

    def perform_request
      params = { id: answer.id, correction: { text: correction.text } }
      post(:create_correction, params: params, xhr: true)
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

  describe 'GET #accepting_correction' do
    let(:correction) { FactoryGirl.create(:correction) }

    def perform_request
      get(:accepting_correction, params: { id: correction.id }, xhr: true)
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

  describe 'POST #accept_correction' do
    let(:correction) { FactoryGirl.create(:correction) }
    let(:accept_correction_form) { AcceptCorrectionForm.from_correction(correction) }

    def perform_request
      params = { id: correction.id, accept_correction_form: { text: accept_correction_form.text } }
      post(:accept_correction, params: params, xhr: true)
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
