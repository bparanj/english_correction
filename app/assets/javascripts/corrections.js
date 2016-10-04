function sendCorrect() {
  put_data = { "text": $('#text_content').val() }
  var request = $.ajax({
      url: '/correct',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name=csrf-token]').attr('content') ) },
      method: "PUT",
      data: JSON.stringify(put_data),
      dataType: "json"
  });

  request.done(function( msg ) {
    content_div = $('#result')

    fixedLocations = msg.fixed_locations

    corrected = msg.corrected
    newText = ''
    for (i = 0; i < corrected.length; i++) {
      text = corrected[i].text.replace(/\n/g, '<br/>')
      if (corrected[i].fixed) {
        loc = fixedLocations[corrected[i].index]
        class_name = (loc.operation == 'added')? 'bg-success' : 'bg-danger'
        signed = (loc.operation == 'added')? '+' : '-'

        text = '<span class="' + class_name + '">'+ signed + loc.delta.replace(/\s/g, '&nbsp;') + '</span>' + text
      }
      newText += text
    }
    // Have no time for formatting
    content_div[0].innerHTML = newText

    content_text_div = $('#result_text')
    content_text_div[0].innerText = msg.corrected_text
  });

  request.fail(function( jqXHR, textStatus ) {
    error_div = $('#request_error')
    error_div[0].className = 'alert-danger text-center ui-corner-all'
    error_div[0].style = 'display: block;'
    if (jqXHR.responseJSON != undefined) {
      error_div[0].innerText = jqXHR.responseJSON['error']
    }
    else {
      error_div[0].innerText = textStatus
    }
    error_div.fadeOut(5000)
  });


  return true
}

form_ready = function() {
  // $('#language_multi_select').val() give you selected values
  $( '#btn_correct' ).bind( 'click', sendCorrect)

};

// Turbo link has its own event
$(document).ready(form_ready)
$(document).on('page:load', form_ready)
