# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Virtual attribute for authentication by either username or email
  attr_accessor :login

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, format: /\A[\da-zA-Z._\-]+\z/, allow_nil: true
  validates :username, length: { within: 3..20 }, allow_nil: true

  validates :fullname, presence: true
  validates :fullname, length: { within: 5..30 }, allow_nil: true

  # Strip value and assign it to fullname.
  def fullname=(value)
    super(value.try(:strip))
  end

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions.to_hash)
      .find_by('username = :value OR lower(email) = lower(:value)', value: login)
  end
end
