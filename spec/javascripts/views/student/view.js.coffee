describe "Student View", ->
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

    @view = new CPP.Views.Students.View
                  model: student
    
    @eventsPartialStub = sinon.stub(window.CPP.Views.Events, "Partial")
                            .returns(new Backbone.View())
    @eventsPartialStub = sinon.stub(window.CPP.Views.Placements, "Partial")
                            .returns(new Backbone.View())

    # @elFindStub = sinon.stub($(@view.el), "find").withArgs('#events-partial', '#placements-partial')

  afterEach ->
    window.CPP.Views.Events.Partial.restore()
    window.CPP.Views.Placements.Partial.restore()

  describe "render", ->
    it "should return self", ->
      expect(@view.render()).toBe(@view)

  describe "Layout", ->
    it "should contain name", ->
      console.log expect(@view.$el).toContain("hi")
      expect(false).toBeTruthy()
      # expect(@view.$el).toContain(@at

  # describe "blah", ->
  #   it "blah blah", ->
  #     @view.render()
  #     console.log $(@view.el).html()
  #     console.log @view.$el.find('a').attr('href')
  #     expect(@view.$el.find('a')).toHaveAttr('href', '/#events/')
