# frozen_string_literal: true
class User < ApplicationRecord
  include Strippable

  has_many :questions, foreign_key: :author_id

  # ActiveModel::Errors uses OrderedHash, so the order
  # validations appear in the model defines the order
  # of displayed error messages.
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, format: /\A[\da-zA-Z._\-]+\z/, allow_blank: true
  validates :username, length: { within: 3..20 }, allow_blank: true

  validates :fullname, presence: true
  validates :fullname, length: { within: 5..30 }, allow_blank: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Virtual attribute for authentication by either username or email
  attr_accessor :login

  strip :fullname

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions.to_hash)
      .find_by('username = :value OR lower(email) = lower(:value)', value: login)
  end
end
