# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Answer creation' do
  given(:question) { FactoryGirl.create(:question) }

  context 'When the user is signed out' do
    scenario "Question view doesn't displays the new answer form" do
      visit question_path(question)
      expect(page).not_to have_css('form#new_answer')
    end
  end

  context 'When the user is signed in' do
    background do
      login_as question.author
      visit question_path(question)
    end

    scenario 'Question view displays the new answer form' do
      expect(page).to have_css('form#new_answer')
    end

    scenario 'Entering invalid answer' do
      within('#new_answer') do
        click_button I18n.t('questions.show.answer')
      end
      expect(page).not_to have_css('.flash-messages', text: I18n.t('answers.create.success'))
      expect(page).to have_css('.error_messages')
    end

    scenario 'Entering valid answer' do
      answer = 'Answer with sufficient length (it has to be at least 20 characters)'
      within('#new_answer') do
        fill_in I18n.t('questions.show.your_answer'), with: answer
        click_button I18n.t('questions.show.answer')
      end
      expect(page).to have_css('.flash-messages', text: I18n.t('answers.create.success'))
      expect(page).not_to have_css('.error_messages')
      expect(page).to have_css('.answer', text: answer)
    end
  end
end
