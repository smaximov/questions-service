# frozen_string_literal: true
require 'rails_helper'

# Load custom matchers
Dir[File.join(__dir__, 'matchers/**/*.rb')].each { |f| require f }

# Add helpers to test matchers
RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers, type: :matcher
end
