class CorrectionsController < ApplicationController
  ERROR_ACTION_CORRECT = 'Error in action correct.'

  def index

  end

  def correct
    process_json_request(ERROR_ACTION_CORRECT) do
      body = JSON.parse(request.body.read)
      raise InvalidDataException.new('The JSON data does not have required value.') unless body.keys.include?('text')
      raise InvalidDataException.new('The JSON data text is not a String.') unless body['text'].is_a?(String)

      corrected_result = Corrector.correct(body['text'])

      render json: corrected_result
    end
  end
end
