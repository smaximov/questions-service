# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Question creation' do
  given(:user) { FactoryGirl.create(:confirmed_user) }

  context 'When the user is signed out' do
    scenario 'Visiting question creation path' do
      visit new_question_path
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context 'When the user is signed in' do
    background { login_as user }

    scenario 'Visiting question creation path' do
      visit new_question_path
      expect(page).to have_current_path(new_question_path)
    end

    scenario 'Entering incomplete question' do
      visit new_question_path
      within('#new_question') do
        fill_in 'Title', with: 'Title with sufficient length'
        click_button 'Create'
      end
      expect(page).not_to have_css('.flash-messages', text: I18n.t('questions.create.success'))
      expect(page).to have_current_path(questions_path(locale: I18n.locale))
      expect(page).to have_css('.error_messages')
    end

    scenario 'Entering invalid question' do
      visit new_question_path
      within('#new_question') do
        fill_in 'Title', with: 'Title with sufficient length'
        fill_in 'Question', with: 'Too short'
        click_button 'Create'
      end
      expect(page).not_to have_css('.flash-messages', text: I18n.t('questions.create.success'))
      expect(page).to have_current_path(questions_path(locale: I18n.locale))
      expect(page).to have_css('.error_messages')
    end

    scenario 'Entering valid question' do
      title = 'Title with sufficient length'
      question = 'Question with sufficient length (it has to be at least 20 characters)'

      visit new_question_path
      within('#new_question') do
        fill_in 'Title', with: title
        fill_in 'Question', with: question
        click_button 'Create'
      end
      expect(page).to have_css('.flash-messages', text: I18n.t('questions.create.success'))
      expect(page).not_to have_current_path(questions_path)
      expect(page).to have_text(title)
      expect(page).to have_text(question)
    end
  end
end
