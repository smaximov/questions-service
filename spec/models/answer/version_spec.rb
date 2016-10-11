# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Answer::Version, type: :model do
  it { is_expected.to belong_to(:previous_version).class_name(::Answer::Version).optional(true) }
end
