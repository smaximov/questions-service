# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Correction creation' do
  given(:answer) { FactoryGirl.create(:answer) }

  context 'When the user is not signed in' do
    scenario "It doesn't have a correction creation button" do
      visit_answer_path
      within_answer do
        expect(page).not_to have_css('.correction-form-btn')
      end
    end
  end

  context 'When the user is signed in' do
    background do
      login_as answer.author
      visit_answer_path
    end

    scenario 'Creating an invalid correction' do
      within_answer do
        click_link I18n.t('answers.answer.suggest_correction')
        within_correction_form do
          fill_in 'correction[text]', with: 'too short'
          click_button I18n.t('answers.answer.suggest_correction')
          expect(page).to have_css('.error_messages')
        end
      end
    end

    scenario 'Creating a valid correction' do
      correction_text = 'correction' * 5
      within_answer do
        click_link I18n.t('answers.answer.suggest_correction')

        within_correction_form do
          fill_in 'correction[text]', with: correction_text
          click_button I18n.t('answers.answer.suggest_correction')
          expect(page).not_to have_css('.error_messages')
        end

        expect(page).to have_text(I18n.t('answers.corrections_meta.pending_corrections', count: 1))
        expect(page).to have_css('.correction.pending', count: 1, text: correction_text)
      end
    end
  end

  def visit_answer_path
    visit answer_permalink_path(answer.id, locale: I18n.locale)
  end

  def within_answer(&block)
    within(".answer[data-id='#{answer.id}']", &block)
  end

  def within_correction_form(&block)
    within('.correction-form', &block)
  end
end
