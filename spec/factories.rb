# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "john.doe-#{n}" }
    sequence(:fullname) { |n| "John Doe #{n}" }
    sequence(:email) { |n| "john.doe-#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end
end
