# coding: utf-8
# frozen_string_literal: true

# EXTRA_USERS to create in addition to ivanov and zoeva
EXTRA_USERS = ENV.fetch('EXTRA_USERS') { 25 }.to_i
# zero to QUESTIONS_PER_USERS questions to create for each user
QUESTIONS_PER_USER = ENV.fetch('QUESTIONS_PER_USER') { 5 }.to_i

# Mandatory users
ivanov = User.create!(username: 'ivanov', fullname: 'Иванов Иван',
                      email: Faker::Internet.email, password: 'foobar',
                      created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

question = <<QUESTION
Живу на ст. метро Октябрьская. Хочу найти ближайшую библиотеку,
но яндекс говорит, что надо ехать на Китай-город. Это слишком
далеко для меня. Кто знает, как быть?
QUESTION
ivanov.questions.create!(title: 'Как пройти в библиотеку?', question: question,
                         created_at: 1.day.ago)

User.create!(username: 'zoeva', fullname: 'Зоя Зоева',
             email: Faker::Internet.email, password: 'foobar',
             created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

# Additional users
EXTRA_USERS.times do |n|
  user = User.create!(username: "user-#{n}", email: "user-#{n}@example.com",
                      fullname: Faker::Name.name, password: 'foobar',
                      created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

  rand(0..QUESTIONS_PER_USER).times do
    user.questions.create!(title: Faker::Hipster.sentence.truncate(50),
                           question: Faker::Hipster.paragraph(5),
                           created_at: Faker::Time.between(user.created_at, Time.current))
  end
end
