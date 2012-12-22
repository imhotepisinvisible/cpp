class CPP.Models.TaggedEmail extends Backbone.Model
  url: ->
    '/tagged_emails' + (if @isNew() then '' else '/' + @id)


  getReadableDate: (field) ->
    Date.parse(@get(field)).toString('dS MMMM yyyy - H:mm')

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

class CPP.Collections.TaggedEmails extends CPP.Collections.Base
  url: '/tagged_emails'
  model: CPP.Models.TaggedEmail
