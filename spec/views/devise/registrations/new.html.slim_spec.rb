# frozen_string_literal: true

require 'rails_helper'
require 'support/devise_user_resource'

Rails.describe 'devise/registrations/new.html.slim', type: :view do
  let(:resource) { double(User).as_null_object }

  before do
    view.extend(DeviseUserResource)
    view.resource = resource
  end

  it 'displays username and fullname fields' do
    render
    expect(rendered).to have_field('user_username')
    expect(rendered).to have_field('user_fullname')
  end
end
