class CPP.Models.Email extends CPP.Models.Base
  url: ->
    '/emails' + (if @isNew() then '' else '/' + @id)

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

class CPP.Collections.Emails extends CPP.Collections.Base
  url: '/emails'
  model: CPP.Models.Email