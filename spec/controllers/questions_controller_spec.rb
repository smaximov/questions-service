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
end
