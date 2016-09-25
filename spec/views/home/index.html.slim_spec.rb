# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'home/index.html.slim', type: :view do
  before { assign(:questions, []) }

  context 'when user is signed in' do
    before { allow(view).to receive(:user_signed_in?).and_return(true) }

    it 'displays no sign up links' do
      render
      expect(rendered).not_to have_link(nil, href: new_user_registration_path)
    end

    it 'displays "My Questions" tab' do
      render
      expect(rendered).to have_link(nil, href: root_path(tab: 'mine'))
    end
  end

  context 'when user is not signed in' do
    before { allow(view).to receive(:user_signed_in?).and_return(false) }

    it 'displays the sign up link' do
      render
      expect(rendered).to have_link(nil, href: new_user_registration_path, count: 1)
    end

    it "doesn't display 'My Questions' tab" do
      render
      expect(rendered).not_to have_link(nil, href: root_path(tab: 'mine'))
    end
  end
end
