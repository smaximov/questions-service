# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET /?tab=mine' do
    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get_mine_tab
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is signed out' do
      let(:user) { FactoryGirl.create(:confirmed_user) }

      before { sign_in user }

      it 'returns http success' do
        get_mine_tab
        expect(response).to have_http_status(:success)
      end
    end
  end

  def get_mine_tab              # rubocop:disable Style/AccessorMethodName
    get :index, params: { tab: 'mine' }
  end
end
