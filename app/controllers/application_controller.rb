class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # This method is tested by all the sub controllers, so there is no need to have unit test for this.
  def process_json_request(error_message)
    yield
  rescue JSON::ParserError => error
    render json: { error: error.message }, status: :unprocessable_entity
  rescue InvalidDataException  => error
    render json: { error: error.message }, status: :unprocessable_entity
  rescue StandardError => error
    Rails.logger.error("Error: #{error.message}\n#{error.backtrace.join("\n")}")
    render json: { error: error_message }, status: :internal_server_error
  end
end
