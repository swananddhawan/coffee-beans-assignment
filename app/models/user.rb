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
            format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "Invalid email format" }

  has_many :events, dependent: :destroy

  private

  def clean_and_sanitize_fields
    self.first_name = self.first_name.strip
    self.last_name = self.last_name.strip

    self.email = self.email.strip.downcase
  end
end
