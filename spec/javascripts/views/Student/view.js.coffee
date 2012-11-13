describe "Students Views", ->
  beforeEach ->
    setFixtures(sandbox id: "app")
    @model = new Backbone.Model()
    @model.events = new Backbone.Collection()
    @model.placements = new Backbone.Collection()
    @view = new CPP.Views.StudentsView
                  model: @model
    @eventsPartialStub = sinon.stub(window.CPP.Views, "EventsPartial")
                            .returns(new Backbone.View())
    @eventsPartialStub = sinon.stub(window.CPP.Views, "PlacementsPartial")
                            .returns(new Backbone.View())

    @elFindStub = sinon.stub($(@view.el), "find").withArgs('#events-partial', '#placements-partial')

  afterEach ->
    window.CPP.Views.EventsPartial.restore()
    window.CPP.Views.PlacementsPartial.restore()

  # describe "blah", ->
  #   it "blah blah", ->
  #     @view.render()
  #     console.log $(@view.el).html()
  #     console.log @view.$el.find('a').attr('href')
  #     expect(@view.$el.find('a')).toHaveAttr('href', '/#events/')
