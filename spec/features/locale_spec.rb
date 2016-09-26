# coding: utf-8
# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Locale' do
  scenario 'Changing preferred language' do
    visit root_path
    within('.navbar') do
      expect(page).to have_css('.change_locale', text: 'Language')
      find('.change_locale').click # Toggle dropdown
      click_link 'Русский'
      expect(page).to have_css('.change_locale', text: 'Язык')
    end
  end

  scenario 'Visiting URIs with the :locale parameter set explicitly' do
    visit root_path(locale: :ru)
    expect(page).to have_css('.navbar .change_locale', text: 'Язык')
  end

  scenario 'Setting Accept-Language HTTP header' do
    page.driver.header 'Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4'
    visit root_path
    expect(page).to have_css('.navbar .change_locale', text: 'Язык')
  end
end
