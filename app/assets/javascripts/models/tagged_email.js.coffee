class CPP.Models.TaggedEmail extends Backbone.Model
  url: ->
    '/tagged_emails' + (if @isNew() then '' else '/' + @id) 

  validation:
    subject:
      required: true
    body:
      required: true

  schema:
    subject:
    	type: "Text"
    body: 
      type: "TextArea"
      editorClass: "tinymce"