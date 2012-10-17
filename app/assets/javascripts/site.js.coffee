# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $("#master-check").bind "click", () ->
    $(".check-boxes").attr 'checked', $("#master-check").is ':checked'

  # Check master if all checked
  $(".check-boxes").bind "click", () ->
    $("#master-check").attr 'checked', $(".check-boxes:checked").length == $(".check-boxes").length

