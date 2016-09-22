# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'home/index.html.slim', type: :view do
  context 'when user is signed in' do
    it 'displays no sign up links' do
      allow(view).to receive(:user_signed_in?).and_return(true)
      render
      expect(rendered).not_to have_link(nil, href: new_user_registration_path)
    end
  end

  context 'when user is not signed in' do
    it 'displays the sign up link' do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
      expect(rendered).to have_link(nil, href: new_user_registration_path, count: 1)
    end
  end
end
