# coding: utf-8
# frozen_string_literal: true

# EXTRA_USERS to create in addition to ivanov and zoeva
EXTRA_USERS = ENV.fetch('EXTRA_USERS') { 25 }.to_i
# zero to QUESTIONS_PER_USER questions to create for each user
QUESTIONS_PER_USER = ENV.fetch('QUESTIONS_PER_USER') { 5 }.to_i
# one to ANSWERS_PER_QUESTION answer for a single question
ANSWERS_PER_QUESTION = ENV.fetch('ANSWERS_PER_QUESTION') { 5 }.to_i
# approx. UNANSWERED_RATIO of questions end up unanswered
UNANSWERED_RATIO = ENV.fetch('UNANSWERED_RATIO') { 0.3 }.to_f
# approx. BEST_ANSWER_RATIO of questions with answers have a best answer
BEST_ANSWERS_RATIO = ENV.fetch('BEST_ANSWERS_RATIO') { 0.6 }.to_f
# each answer has up to CORRECTIONS_PER_ANSWER accepted corrections
CORRECTIONS_PER_ANSWER = ENV.fetch('CORRECTIONS_PER_ANSWER') { 3 }.to_i

# Mandatory users
ivanov = User.create!(username: 'ivanov', fullname: 'Иванов Иван',
                      email: Faker::Internet.email, password: 'foobar',
                      created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

ivanovs_question = <<QUESTION
Живу на ст. метро Октябрьская. Хочу найти ближайшую библиотеку,
но яндекс говорит, что надо ехать на Китай-город. Это слишком
далеко для меня. Кто знает, как быть?
QUESTION
ivanovs_question = ivanov.questions.create!(title: 'Как пройти в библиотеку?',
                                            question: ivanovs_question, created_at: 1.day.ago)

zoeva = User.create!(username: 'zoeva', fullname: 'Зоя Зоева',
                     email: Faker::Internet.email, password: 'foobar',
                     created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

nikitin = User.create!(username: 'nikita.nikitin', fullname: 'Никита Никитин',
                       email: Faker::Internet.email, password: 'foobar',
                       created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

zoevas_answer = <<ANSWER
На Октябрьской рядом с южным выходом между полицейской будкой и
трещиной в стене есть полуржавая дверь, которая временами
бывает открытой. За ней лежат утерянные архивы Ленинки.
ANSWER
zoevas_answer = ivanovs_question.answers.create!(answer: zoevas_answer, author: zoeva,
                                                 created_at: rand(ivanovs_question.created_at..Time.current))

nikitins_correction = <<CORRECTION
Полуржавая дверь открыта в субботам и воскресениями с 7 до 9 утра,
по крайней мере я всегда в это время попадаю
CORRECTION
nikitins_correction = zoevas_answer.corrections.create!(text: nikitins_correction, author: nikitin,
                                                        created_at: rand(zoevas_answer.created_at..Time.current))
nikitins_correction.accept(AcceptCorrectionForm.from_correction(nikitins_correction))

users = Array.new(EXTRA_USERS) do |n|
  user = User.create!(username: "user-#{n}", email: "user-#{n}@example.com",
                      fullname: Faker::Name.name, password: 'foobar',
                      created_at: 1.year.ago, confirmed_at: 1.year.ago + 5.minutes)

  rand(0..QUESTIONS_PER_USER).times do
    user.questions.create!(title: Faker::Hipster.sentence.truncate(200),
                           question: Faker::Hipster.paragraph(5),
                           created_at: rand(user.created_at..Time.current))
  end

  user
end

all_users = User.all

users.each do |user|
  user.questions.find_each do |question|
    next if rand < UNANSWERED_RATIO

    answers = Array.new(rand(1..ANSWERS_PER_QUESTION)) do
      question.answers.create!(answer: Faker::Hipster.paragraph(5), author: all_users.sample,
                               created_at: rand(question.created_at..Time.current))
    end

    next if rand >= BEST_ANSWERS_RATIO

    answers.sample.mark_as_best
  end
end

zoevas_question = zoeva.questions.create!(title: Faker::Hipster.sentence.truncate(200),
                                          question: Faker::Hipster.paragraph(5),
                                          created_at: 2.days.ago)
# Rather long list of answers to demonstrate pagination
75.times do
  zoevas_question.answers.create!(answer: Faker::Hipster.paragraph(5), author: all_users.sample,
                                  created_at: rand(zoevas_question.created_at..Time.current))
end

Answer.where.not(id: zoevas_answer.id).find_each do |answer|
  rand(0..CORRECTIONS_PER_ANSWER).times do
    created_at = rand(answer.created_at..Time.current)
    correction = answer.corrections.create!(text: Faker::Hipster.paragraph, author: all_users.sample,
                                            created_at: created_at)
    correction.accept(AcceptCorrectionForm.from_correction(correction))
  end
end
