class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing do |exception|
    render status: :bad_request,
           json: exception_response(exception)
  end

  private

  def exception_response(exception)
    {
      data: nil,
      message: exception.message,
      errors: [exception]
    }
  end

  # NOTE: Currently, hard-coding this user-id for initial version.
  # This was created from the seed data.
  # Refer `db/seeds.rb` file for further details.
  def current_user_id
    'a0a3b3c6-1608-44cc-9264-99e9ec812fbd'
  end
end
