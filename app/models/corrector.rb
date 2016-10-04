# There is no need to create instance of this class
class Corrector
  class << self
    def correct(text)
      fixed_locations = []
      lines = text.split('.')
      # if there is only blank, one sentence or a text with no '.', there is nothing todo
      return build_result([ {text: text, fixed: false} ], fixed_locations) if [0,1].include?(lines.size)

      corrected = [ {text: lines[0], fixed: false} ]
      location = lines[0].size + 1 # +1 for .

      1.upto(lines.size - 1) do |i|
        result = correct_sentence(lines[i])
        if result == {}
          corrected << { text: lines[i], fixed: false }
          location += lines[i].size + 1
          next
        end

        fixed_locations << { operation: result['operation'], delta: result[:delta], location: location }
        corrected << { text: result['new_text'], fixed: true, index: fixed_locations.size - 1 }
        location += lines[i].size + 1
      end

      build_result(corrected, fixed_locations, text.end_with?('.'))
    end

    # Requirement: it contains exactly one space AFTER a period between sentences
    # Don't have to check about space or anything before the dot
    # Don't have to check .. (The sentence between 2 . is blank) and other cases of blank sentence
    def correct_sentence(sentence)
      result = {}
      return result if sentence.blank? || sentence.match(/^\s(\S+)/) || sentence.match(/^(\s+)$/)

      # Now there are only 2 remaining cases:
      # 1. There is no space at the beginning
      if sentence.match(/^(\S+)/)
        return { operation: :added, delta: ' ', new_text: " #{sentence}"   }.with_indifferent_access
      end

      # 2. There are more than 1 spaces at the beginning
       m = sentence.match(/^(\s+)/)
      { operation: :removed, delta: ' ' * (m.to_s.size - 1), new_text: " #{m.post_match}"   }.with_indifferent_access
    end


    # This method is tested indirectly in the method correct, so there is no need to write tests.
    def build_result(corrected, fixed_locations, end_with_dot = false)
      corrected.map! { |x| {text: x[:text] + '.', fixed: x[:fixed], index: x[:index] } }
      unless  end_with_dot
        corrected.last[:text] = corrected.last[:text][0, corrected.last[:text].size - 1]
      end
      corrected_text = corrected.map { |x| x[:text] }.join('')

      {
        corrected_text: corrected_text,
        corrected: corrected,
        fixed_locations: fixed_locations
      }.with_indifferent_access
    end
  end
end
