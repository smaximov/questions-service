# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }

  describe 'POST #create' do
    context 'when the user is not signed in' do
      it 'redirects to the sign in page' do
        post :create, params: { id: question.id }
        expect(response).to redirect_to(new_user_session_path(locale: nil))
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
end
