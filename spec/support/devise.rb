# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature

  config.after(:each, type: :feature) { Warden.test_reset! }
end
