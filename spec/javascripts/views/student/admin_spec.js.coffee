describe "Student Admin", ->
  beforeEach ->
    setFixtures(sandbox id: "app")

    @attrs = 
      first_name: 'Sarah'
      last_name: 'Tattersall'
      departments: ['doc']
      email: 'st@email.com'
      password: 'aaaaaaaa'
      password_confirmation: 'aaaaaaaa'
      year: '3'
      degree: 'MEng Computing'
      looking_for: 'Not looking for anything'
      bio: 'bio'
      skill_list: []
      interest_list: []
      year_group_list: []


    student = new CPP.Models.Student @attrs

    @view = new CPP.Views.Students.Admin
                  model: student
                  
    @form = new Backbone.Form({
        model: student
        schema: {
          first_name: {
            title: 'First Name',
            type: 'Text'
          },
          last_name: {
            title: 'Last Name',
            type: 'Text'
          },
          year: {
            title: 'Year',
            type: 'Number'
          },
          degree: {
            title: 'Degree',
            type: 'Text'
          },
          bio: {
            title: 'About Me',
            type: 'TextArea'
          },
          looking_for: {
            title: 'Looking for',
            type: 'Select',
            options: [
              looking_fors.industrial, looking_fors.summer, looking_fors.graduate, {
                val: '',
                label: looking_fors.nothing
              }
            ]
          }
        }
    })
    @backboneFormStub = sinon.stub(window.Backbone, "Form").returns(@form)

  afterEach ->
    window.Backbone.Form.restore()

  describe "Instantiation", ->
    it "should create a backbone form", ->
      expect(@backboneFormStub).toHaveBeenCalledOnce()
      expect(@backboneFormStub).toHaveBeenCalledWith model: @model

  describe "render", ->
    it "should return self", ->
      expect(@view.render()).toBe(@view)
      
