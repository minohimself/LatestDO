#
#$ ->

## $('#novaPosta input').focus()
#$(document).ready (function() {
#$(".novaPostaBtn").click(function () {
#$("#novaPosta").toggle();
#});
#});

$(document).ready ->
  $("#new_postum").on("ajax:success", (e, data, status, xhr) ->
    response = xhr.responseJSON
    $("#notation").html("")
    $("#notation").fadeIn()
    $("#notation").append("Posta odoslana")



  )
  .bind "ajax:error", (e, xhr, status, error) ->
      alert("error")
      $("#new_postum").append xhr.responseText
  .bind "ajax:complete", (evt, xhr, status) ->
      $("#notation").fadeOut(1500)
      $form = $(this)
      $form.find('textarea,input[type="text"],input[type="file"]').val("")



#$(document).on 'click', '.novaPostaBtn', ->
#  $('#novaPosta').toggle(500);


