# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Signing in' do
  let(:user) { FactoryGirl.create(:confirmed_user) }

  scenario 'Using username as login' do
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Login', with: user.username
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
    expect(page).to have_css('.flash-messages .alert-notice', text: 'successfully')
    expect(page).to have_current_path(root_path(locale: I18n.default_locale))
  end

  scenario 'Using email as login' do
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Login', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
    expect(page).to have_css('.flash-messages .alert-notice', text: 'successfully')
    expect(page).to have_current_path(root_path(locale: I18n.default_locale))
  end
end
