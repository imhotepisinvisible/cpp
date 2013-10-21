# Changes the model schema
# Used for events and placements when a department is creating an event
# Will give department option to select company rather than the schema of
# the model which origionally exists with a department schema
window.swapDepartmentToCompanySchema = (model, department) ->
    schema = model.schema()

    if model.isNew()
      schema['company_id'] = {
        title: "Company*"
        type: "Select"
        template: "field"
        options: department.companies
        editorClass: "company-select"
      }
      
      model.set 'departments', [department.id]

    delete schema["departments"]
    model.schema = -> schema

# To be used with backbone forms as so:
# validateField(@form, field) for field of @form.fields
window.validateField = (form, field) ->
    form.on "#{field}:change", (form, fieldEditor) =>
      form.fields[field].clearError()
      if form.fields[field].validators
        form.fields[field].validate()

      errors = form.model.preValidate(field, form.fields[field].getValue())
      if (errors)
        form.fields[field].setError(errors)

# Returns if a user (student) is planning to attend an event
window.studentAttendEvent = (event) ->
  isStudent() && event.registered_students.get(userId()) != undefined

# Looking for status options for students
window.looking_fors = {
  summer: "Looking for a Summer Placement"
  industrial: "Looking for an Industrial Placement"
  graduate: "Looking for a Graduate Job"
  nothing: "Not looking for anything"
  graduateSecured: "Secured graduate position"
  summerSecured: "Secured summer internship"
  industrialSecured: "Secured industrial placement"
}

window.addPlacementTableRow = (placement, attr, label) ->
  val = placement.get attr
  if val then "<tr><td>#{label}:</td><td>#{val}</td></tr>" else ''