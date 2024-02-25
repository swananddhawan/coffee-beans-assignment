# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  before_validation :clean_and_sanitize_fields

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: URI::MailTo::EMAIL_REGEXP

  has_many :events, dependent: :destroy

  private

  def clean_and_sanitize_fields
    self.first_name = first_name.to_s.strip
    self.last_name = last_name.to_s.strip

    self.email = email.to_s.strip.downcase
  end
end
