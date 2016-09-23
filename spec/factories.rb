# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "john.doe-#{n}" }
    sequence(:fullname) { |n| "John Doe #{n}" }
    sequence(:email) { |n| "john.doe-#{n}@example.com" }
    password 'password'
    password_confirmation 'password'

    factory :confirmed_user, aliases: [:author] do
      confirmed_at { Time.zone.now }

      factory :user_with_questions do
        transient do
          question_count 5
        end

        after(:create) do |user, evaluator|
          create_list(:question, evaluator.question_count, author: user)
        end
      end
    end
  end

  factory :question do
    sequence(:title) { |n| "Question ##{n} by #{author.fullname}" }
    sequence(:question) { |n| "Body of the question ##{n} by #{author.fullname}" }
    author
  end
end
