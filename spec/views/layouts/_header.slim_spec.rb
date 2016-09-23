# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/_header.slim', type: :view do
  context 'when user is not signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
    end

    it 'displays the sign up link' do
      expect(rendered).to have_link(nil, href: new_user_registration_path, count: 1)
    end

    it 'displays the sign in link' do
      expect(rendered).to have_link(nil, href: new_user_session_path, count: 1)
    end

    it 'displays no sign out links' do
      expect(rendered).not_to have_link(nil, href: destroy_user_session_path)
    end

    it 'displays no "new question" links' do
      expect(rendered).not_to have_link(nil, href: new_question_path)
    end
  end

  context 'when user is signed in' do
    let(:user) { instance_double(User) }

    before do
      allow(user).to receive(:username).and_return('likely-to_be.unique')
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
      render
    end

    it 'displays no sign up links' do
      expect(rendered).not_to have_link(nil, href: new_user_registration_path)
    end

    it 'displays the sign out link' do
      expect(rendered).to have_link(nil, href: destroy_user_session_path, count: 1)
    end

    it 'displays no sign in links' do
      expect(rendered).not_to have_link(nil, href: new_user_session_path)
    end

    it "displays the user's username" do
      expect(rendered).to have_text('likely-to_be.unique')
    end

    it 'displays the "new question" link' do
      expect(rendered).to have_link(nil, href: new_question_path, count: 1)
    end
  end
end
