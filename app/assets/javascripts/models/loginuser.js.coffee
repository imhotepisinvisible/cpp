class CPP.Models.LoginUser extends Backbone.Model
  schema:
    email:
      type: "Text"
      editorClass: "input-small"
    password:
      type: "Password"
      editorClass: "input-small"

  url: ->
    "sessions"
