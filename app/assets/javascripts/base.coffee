@showMesage = (type, messages) ->
  if messages? && messages.length > 0
    $(".alert-#{type} div").remove()
    for message, index in messages.split("\n")
      $(".alert-#{type}").append("<div><span class='glyphicon glyphicon-exclamation-sign' aria-hidden></span> "+message+"</div>")
      $(".alert-#{type}").show()

@showInfo = (messages) ->
  showMesage('info', messages)

@showAlert = (messages) ->
  showMesage('danger', messages)
