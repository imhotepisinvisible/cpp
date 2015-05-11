describe "Student Edit", ->
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

    @view = new CPP.Views.Students.Edit
                  model: student
        
  describe "render", ->
    it "should return self", ->
      expect(@view.render()).toBe(@view)