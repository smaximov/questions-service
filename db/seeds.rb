# coding: utf-8
# frozen_string_literal: true

EXTRA_USERS = ENV.fetch('EXTRA_USERS') { 10 }.to_i

# Create a new user, skipping email confirmation.
def create_user(options = {})
  id = options.delete(:id)

  options[:username] ||= id ? "anonymous#{id}" : Faker::Internet.user_name
  options[:email] ||= id ? "anonymous#{id}@example.com" : Faker::Internet.email
  options[:fullname] ||= Faker::Name.name
  options[:password] ||= Faker::Internet.password
  options[:confirmed_at] ||= Time.zone.now

  User.create!(options)
end

# Mandatory users
create_user(username: 'ivanov', fullname: 'Иванов Иван', password: 'foobar')
create_user(username: 'zoeva', fullname: 'Зоя Зоева', password: 'foobar')

EXTRA_USERS.times { |n| create_user(id: n) }
