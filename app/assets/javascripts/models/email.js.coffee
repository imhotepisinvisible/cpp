class CPP.Models.Email extends Backbone.Model
  url: ->
    '/emails' + (if @isNew() then '' else '/' + @id) 

  schema:
    subject:
    	type: "Text"
    	validators: ["required"]
    body: 
      type: "TextArea"
      validators: ["required"]
      editorClass: "tinymce"
