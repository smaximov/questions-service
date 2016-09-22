# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/_header.slim', type: :view do
  context 'when user is not signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
    end

    it 'displays the sign in link' do
      expect(rendered).to have_link(nil, href: new_user_session_path, count: 1)
    end

    it 'displays no sign out links' do
      expect(rendered).not_to have_link(nil, href: destroy_user_session_path)
    end
  end

  context 'when user is signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
      render
    end

    it 'displays the sign out link' do
      expect(rendered).to have_link(nil, href: destroy_user_session_path, count: 1)
    end

    it 'displays no sign in links' do
      expect(rendered).not_to have_link(nil, href: new_user_session_path)
    end
  end
end
