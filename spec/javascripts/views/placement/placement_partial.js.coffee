describe "Placement Partial", ->
  beforeEach ->
    setFixtures(sandbox id: "placements")
    @event = new Backbone.Model id: 1
    @model = new Backbone.Model()
    @collection = new Backbone.Collection()
    @collection.add @model

    @partialView = new Backbone.View()
    @partialView.el = '<div "id=item"></div>'

    @renderStub = sinon.stub(@partialView, "render").returns(@partialView)

    @partialStub = sinon.stub(window.CPP.Views, "PlacementsPartialItem")
                      .returns(@partialView)

    @placementsPartial = new CPP.Views.Placements.Partial
                              el: "#placements"
                              model: @event
                              collection: @collection

  afterEach ->
    window.CPP.Views.Placements.PartialItem.restore()

  describe "initialize", ->
    it "should have editable attribute default to false", ->
      expect(@placementsPartial.editable).toBeFalsy()

  describe "render", ->
    it "should add collection items", ->
      expect(@partialStub).toHaveBeenCalledOnce()
      expect(@partialStub).toHaveBeenCalledWith model: @model, editable: false

    it "should render partial items", ->
      @expect(@renderStub).toHaveBeenCalledOnce()

  describe "buttons", ->
    describe "when editable", ->
      beforeEach ->
        @placementsPartial.editable = true
        @placementsPartial.render()

      describe "add button", ->
        it "Should be displayed", ->
          expect(@placementsPartial.$el.find 'div').toHaveClass('btn-add')

        it "should navigate to add screen when clicked", ->
          spyEvent = spyOnEvent('.btn-add', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/placements/new', trigger: true)
          $('.btn-add').click()
          expect('click').toHaveBeenTriggeredOn('.btn-add')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()

      describe "view all button", ->
        it "Should be displayed", ->
          expect(@placementsPartial.$el.find 'div').toHaveClass('btn-view-all')

        it "should navigate to view all screen", ->
          spyEvent = spyOnEvent('.btn-view-all', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/placements', trigger: true)
          $('.btn-view-all').click()
          expect('click').toHaveBeenTriggeredOn('.btn-view-all')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()

    describe "when not editable", ->
      describe "add button", ->
        it "Should not be displayed", ->
          expect(@placementsPartial.$el.find 'div').not.toHaveClass('btn-edit')

      describe "view all button", ->
        it "Should be displayed", ->
          expect(@placementsPartial.$el.find 'div').toHaveClass('btn-view-all')

        it "should navigate to view all screen", ->
          spyEvent = spyOnEvent('.btn-view-all', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/placements', trigger: true)
          $('.btn-view-all').click()
          expect('click').toHaveBeenTriggeredOn('.btn-view-all')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()


