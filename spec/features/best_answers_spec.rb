# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Best answers' do
  given(:user) { FactoryGirl.create(:confirmed_user) }
  given(:other_user) { FactoryGirl.create(:confirmed_user) }
  given(:question) { FactoryGirl.create(:question, author: user) }
  given(:answer_count) { 2 }
  given(:displayed_answers_count) { [answer_count, Answer::ANSWERS_PER_PAGE].min }

  background { FactoryGirl.create_list(:answer, answer_count, question: question) }

  scenario 'Displaying correct number of answers' do
    visit_question_path

    answer_count_text = "#{answer_count} #{I18n.t('shared.answers', count: answer_count)}"
    expect(page).to have_css('.answer-count', text: answer_count_text)
  end

  context 'When not not signed in' do
    background { visit_question_path }

    scenario 'It displays no "Mark as best" buttons' do
      expect(page).not_to have_css('button[type="submit"]', text: mark_as_best_button)
    end
  end

  context 'When signed in as other user' do
    background do
      login_as other_user
      visit_question_path
    end

    scenario 'It displays no "Mark as best" buttons' do
      expect(page).not_to have_css('button[type="submit"]', text: mark_as_best_button)
    end
  end

  context "When signed in as the questions's author" do
    background do
      login_as user
      visit_question_path
    end

    scenario 'It displays "Mark as best" buttons on answers' do
      expect(page).to have_css('button[type="submit"]',
                               text: mark_as_best_button,
                               count: displayed_answers_count)
    end

    scenario 'Marking/unmarking best answers' do
      answer = question.answers.sample
      answer_selector = "#answer-#{answer.id}"

      within answer_selector do
        click_button mark_as_best_button
      end

      expect(page).to have_css('.best-answer', text: I18n.t('questions.show.best_answer'))

      within answer_selector do
        click_button best_answer_button
      end

      expect(page).not_to have_css('.best-answer', text: I18n.t('questions.show.best_answer'))
    end
  end

  private

  def visit_question_path
    visit question_path(question)
  end

  def mark_as_best_button
    I18n.t('answers.best_answer_button.mark')
  end

  def best_answer_button
    I18n.t('answers.best_answer_button.best')
  end
end
