# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

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
end
