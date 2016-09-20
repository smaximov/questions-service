# frozen_string_literal: true

require 'rails_helper'
require 'support/devise_user_resource'

Rails.describe 'devise/sessions/new.html.slim', type: :view do
  let(:resource) { double(User).as_null_object }

  before do
    view.extend(DeviseUserResource)
    view.resource = resource
  end

  it 'should use login field for authentication' do
    render
    expect(rendered).to have_field('user_login')
    expect(rendered).not_to have_field('user_email')
  end
end
