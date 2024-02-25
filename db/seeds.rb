# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(
  id: 'a0a3b3c6-1608-44cc-9264-99e9ec812fbd',
  email: 'swananddhawan@gmail.com',
  first_name: 'Swanand',
  last_name: 'Dhawan'
)
