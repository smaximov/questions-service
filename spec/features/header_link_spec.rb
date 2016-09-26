# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Header Links' do
  scenario 'When the user is not signed in' do
    visit root_path
    within '.navbar' do
      expect(page).to have_link('Sign up', href: new_user_registration_path(locale: :en), count: 1)
      expect(page).to have_link('Sign in', href: new_user_session_path(locale: :en), count: 1)
      expect(page).not_to have_link(nil, href: destroy_user_session_path(locale: :en), visible: false)
      expect(page).not_to have_link(nil, href: new_question_path(locale: :en))
    end
  end

  scenario 'When the user is signed in' do
    user = FactoryGirl.create(:confirmed_user)
    login_as user
    visit root_path
    within '.navbar' do
      expect(page).to have_text(user.username)
      find('.user-menu').click # Toggle dropdown
      expect(page).to have_link('New question', href: new_question_path(locale: :en), count: 1)
      expect(page).to have_link('Sign out', href: destroy_user_session_path(locale: :en), count: 1)
      expect(page).not_to have_link(nil, href: new_user_registration_path(locale: :en))
      expect(page).not_to have_link(nil, href: new_user_session_path(locale: :en))
    end
  end
end
