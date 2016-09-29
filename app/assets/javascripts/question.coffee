$(document).on 'turbolinks:load', ->
  $("#{window.location.hash}.answer").addClass('focused') if window.location.hash
