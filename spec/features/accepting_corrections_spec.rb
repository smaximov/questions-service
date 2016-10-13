# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Accepting corrections' do
  given(:correction) { FactoryGirl.create(:correction) }
  given(:answer) { correction.answer }
  given(:accepted_correction_text) { answer.current_version.text + ' ' + correction.text }

  context 'When the user is not signed in' do
    scenario 'Pending corrections not displayed' do
      visit_answer_path
      within_answer do
        expect(page).not_to have_css('.correction.pending')
      end
    end
  end

  context "When signed in as the correction's author" do
    background do
      login_as correction.author
      visit_answer_path
    end

    scenario "It doesn't have the 'Accept correction' button" do
      within_answer do
        within_correction pending: true do
          expect(page).not_to have_css('.accept-correction-btn')
        end
      end
    end
  end

  context "When signed in as the answer's author" do
    background do
      login_as answer.author
      visit_answer_path
    end

    scenario 'Displaying the number of pending corrections' do
      within_answer do
        expect(page).to have_text(I18n.t('answers.corrections_meta.pending_corrections', count: 1))
      end
    end

    scenario 'Accepting malformed correction' do
      within_correction pending: true do
        click_link I18n.t('corrections.correction.accept')

        within_accept_correction_form do
          expect(page).to have_field('accept_correction_form[text]', text: accepted_correction_text)
          fill_in 'accept_correction_form[text]', with: ''
          click_button I18n.t('corrections.correction.accept')
          expect(page).to have_css('.error_messages')
        end
      end
    end

    scenario 'Accepting valid correction' do
      within_answer do
        within_correction pending: true do
          click_link I18n.t('corrections.correction.accept')

          within_accept_correction_form do
            expect(page).to have_field('accept_correction_form[text]', text: accepted_correction_text)
            click_button I18n.t('corrections.correction.accept')
            expect(page).not_to have_css('.error_messages')
          end
        end

        expect(page).to have_text(accepted_correction_text)
        expect(page).to have_text(I18n.t('answers.corrections_meta.corrections', count: 1))

        within_correction pending: false do
          expect(page).to have_text(accepted_correction_text)
        end
      end
    end
  end

  def visit_answer_path
    visit answer_permalink_path(answer.id, locale: I18n.locale)
  end

  def within_answer(&block)
    within(".answer[data-id='#{answer.id}']", &block)
  end

  def within_correction(pending:, &block)
    class_list = pending ? '.correction.pending' : '.correction'
    within("#{class_list}[data-id='#{correction.id}']", &block)
  end

  def within_accept_correction_form(&block)
    within('.accept-correction-form', &block)
  end
end
