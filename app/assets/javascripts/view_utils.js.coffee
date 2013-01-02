# TODO: Possibly move to view utils?
window.swapDepartmentToCompanySchema = (model, department) ->
    # If model doesn't have a company yet, i.e. admin
    # Need to add to the schema a comapny select
    # TODO: Is there a better way to do this?
    schema = model.schema()
    schema['company_id'] = {
      title: "Company*"
      type: "Select"
      template: "field"
      options: department.companies
      editorClass: "company-select"
    }
    delete schema["departments"]

    model.set('departments', [department.id])
    model.save()
    model.schema = -> 
      schema

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

window.studentAttendEvent = (event) ->
  isStudent && event.registeredStudents.get(userId()) != undefined