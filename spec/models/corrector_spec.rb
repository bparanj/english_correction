require 'rails_helper'

describe Corrector do
  context 'correct' do
    it 'corrects the text and returns result for empty text' do
      result = Corrector.correct('')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('')
      expect(result['fixed_locations']).to eql([])
    end

    it 'corrects the text and returns result for one sentence with .' do
      result = Corrector.correct('This is a sample text.')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text.')
      expect(result['fixed_locations']).to eql([])
    end

    it 'corrects the text and returns result for one sentence without .' do
      result = Corrector.correct('This is a sample text ')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text ')
      expect(result['fixed_locations']).to eql([])
    end

    it 'corrects the text and returns result for text with no error' do
      result = Corrector.correct('This is a sample text. Next sentence.')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text. Next sentence.')
      expect(result['fixed_locations']).to eql([])
    end

    it 'corrects the text and returns result for text with error (removed)' do
      result = Corrector.correct('This is a sample text.   Next sentence.')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text. Next sentence.')
      expect(result['fixed_locations'].to_json).to eql([{ operation: :removed, delta: '  ', location: 22}].to_json)
    end

    it 'corrects the text and returns result for text with error (added)' do
      result = Corrector.correct('This is a sample text.Next sentence.')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text. Next sentence.')
      expect(result['fixed_locations'].to_json).to eql([{ operation: :added, delta: ' ', location: 22}].to_json)
    end

    it 'corrects the text and returns result for text with error (added) and ..' do
      result = Corrector.correct('This is a sample text..Next sentence.')

      expect(result.is_a? Hash).to be true

      # Technically don't check for ..
      expect(result['corrected_text']).to eql('This is a sample text.. Next sentence.')
      expect(result['fixed_locations'].to_json).to eql([{ operation: :added, delta: ' ', location: 23}].to_json)
    end

    it 'corrects the text and returns result for text with error (added), no . at the end' do
      result = Corrector.correct('This is a sample text.Next sentence')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text. Next sentence')
      expect(result['fixed_locations'].to_json).to eql([{ operation: :added, delta: ' ', location: 22}].to_json)
    end

    it 'corrects the text and returns result for text with error (added), no . at the end, with many spaces' do
      result = Corrector.correct('This is a sample text.Next sentence.   ')

      expect(result.is_a? Hash).to be true
      expect(result['corrected_text']).to eql('This is a sample text. Next sentence.   ')
      expect(result['fixed_locations'].to_json).to eql([{ operation: :added, delta: ' ', location: 22}].to_json)
    end

  end

  context 'correct_sentence' do
    it 'returns empty hash if sentence is blank' do
      result = Corrector.correct_sentence('')
      expect(result.is_a? Hash).to be true
      expect(result).to eql({})
    end

    it 'returns empty hash if there are only spaces' do
      result = Corrector.correct_sentence('   ')
      expect(result.is_a? Hash).to be true
      expect(result).to eql({})
    end

    it 'returns empty hash if there is nothing to correct' do
      result = Corrector.correct_sentence(' Next sentence')
      expect(result.is_a? Hash).to be true
      expect(result).to eql({})
    end

    it 'returns a hash with operation added if there is no space at the beginning' do
      result = Corrector.correct_sentence('Next sentence')
      expect(result.is_a? Hash).to be true
      expect(result['operation']).to eql(:added)
      expect(result['delta']).to eql(' ')
      expect(result['new_text']).to eql(' Next sentence')
    end

    it 'returns a hash with operation removed if there are many spaces at the beginning' do
      result = Corrector.correct_sentence('     Next sentence')
      expect(result.is_a? Hash).to be true
      expect(result['operation']).to eql(:removed)
      expect(result['delta']).to eql('    ')
      expect(result['new_text']).to eql(' Next sentence')
    end
  end
end
