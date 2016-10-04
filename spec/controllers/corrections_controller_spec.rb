require 'rails_helper'

describe CorrectionsController do
  context 'correct' do
    before :all do
      @sample_text = { text: 'This is a sample text.' }
    end

    it 'receives a text and send an answer' do
      request.env['RAW_POST_DATA'] = @sample_text.to_json
      put :correct, params: { format: :json }

      expect(response).to have_http_status(:ok)
      correction_info = JSON.parse(response.body)
      expect(correction_info.is_a? Hash).to be true

    end

    it 'returns unprocessable_entity if the request body is not a valid JSON' do
      request.env['RAW_POST_DATA'] = 'Wrong format'
      put :correct, params: { format: :json }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns unprocessable_entity if the request body does not contain element text' do
      request.env['RAW_POST_DATA'] = { wrong_key: 'This is a sample text.' }.to_json
      put :correct, params: { format: :json }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns unprocessable_entity if the text value is not a String' do
      request.env['RAW_POST_DATA'] = { text: 5}.to_json
      put :correct, params: { format: :json }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns internal_server_error if generic error happens' do
      allow(Corrector).to receive(:correct).and_raise('Something wrong happens')
      request.env['RAW_POST_DATA'] = @sample_text.to_json
      put :correct, params: { format: :json }
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
