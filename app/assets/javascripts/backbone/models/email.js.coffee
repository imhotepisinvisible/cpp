class CPP.Models.Email extends CPP.Models.Base

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