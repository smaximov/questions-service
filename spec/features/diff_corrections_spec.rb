# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Diff corrections' do
  given(:correction) { FactoryGirl.create(:correction) }
  given(:previous_version) { answer.current_version.previous_version }
  given(:answer) { correction.answer }

  background do
    correction.accept(AcceptCorrectionForm.from_correction(correction))
  end

  scenario 'Displaying diffs' do
    visit_answer_path

    within_correction pending: false do
      expect(page).to have_css('.diff-anchor', text: I18n.t('corrections.correction.accepted'))
      click_link I18n.t('corrections.correction.accepted')
      expect(page).to have_css('span', text: previous_version.text)
      expect(page).to have_css('ins', text: correction.text)
    end
  end

  def visit_answer_path
    visit answer_permalink_path(answer.id, locale: I18n.locale)
  end

  def within_correction(pending:, &block)
    class_list = pending ? '.correction.pending' : '.correction'
    within("#{class_list}[data-id='#{correction.id}']", &block)
  end
end
