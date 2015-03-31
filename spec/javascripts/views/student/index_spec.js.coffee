describe "Student Index View", ->
  beforeEach ->
    setFixtures(sandbox id: "app")

    @attrs1 = 
      id:1
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

    @attrs2 = 
      id:2
      first_name: 'Marah'
      last_name: 'Battersall'
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

    @attrs3 =
      name: "Computing"
      id: 1

    @attrs4 =
      name: "Computing2"
      id: 2

    @b1 = new CPP.Models.Course @attrs3      
    @b2 = new CPP.Models.Course @attrs4

    @courses = new CPP.Collections.Courses 
    @courses.add(@b1)
    @courses.add(@b2)

    @c1 = new CPP.Models.Student @attrs1
    @c2 = new CPP.Models.Student @attrs2
    @cc = new CPP.Collections.Students 
    @cc.add(@c1)
    @cc.add(@c2)

    @view = new CPP.Views.Students.Index collection: @cc 
                 
  describe "render", ->
    it "should return self", ->
      console.log @cc
      @courses = new CPP.Collections.Courses 
      @courses.add(@b1)
      @courses.add(@b2)
      expect(@view.render()).toBeDefined()
