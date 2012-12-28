describe "Events Partial", ->
  beforeEach ->
    setFixtures(sandbox id: "events")
    @event = new Backbone.Model id: 1

    @collection = new Backbone.Collection()
    @collection.add(new Backbone.Model id: 1)

    @partialView = new Backbone.View()
    @partialView.el = '<div "id=item"></div>'

    @renderStub = sinon.stub(@partialView, "render").returns(@partialView)

    @partialStub = sinon.stub(window.CPP.Views.Events, "PartialItem")
                      .returns(@partialView)


    @eventsPartial = new CPP.Views.Events.Partial
                              el: "#events"
                              model: @event
                              collection: @collection

  afterEach ->
    window.CPP.Views.Events.PartialItem.restore()

  describe "initialize", ->
    it "should have editable attribute default to false", ->
      expect(@eventsPartial.editable).toBeFalsy()

  describe "render", ->
    it "should return itself", ->
      expect(@eventsPartial.render()).toBe(@eventsPartial)

    it "should add top three", ->
      for id in [1..4]
        do (id) =>
          @collection.add new Backbone.Model id: id

      @eventsPartial.render()

      expect(@partialStub).toHaveBeenCalledThrice()

  describe "buttons", ->
    describe "when editable", ->
      beforeEach ->
        @eventsPartial.editable = true
        @eventsPartial.render()

      describe "add button", ->
        it "Should be displayed", ->
          console.log "el", @eventsPartial.$el
          expect(@eventsPartial.$el.find 'div').toHaveClass('btn-add')

        it "should navigate to add screen when clicked", ->
          spyEvent = spyOnEvent('.btn-add', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/events/new', trigger: true)
          $('.btn-add').click()
          expect('click').toHaveBeenTriggeredOn('.btn-add')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()

      describe "view all button", ->
        it "Should be displayed", ->
          expect(@eventsPartial.$el.find 'div').toHaveClass('btn-view-all')

        it "should navigate to view all screen", ->
          spyEvent = spyOnEvent('.btn-view-all', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/events', trigger: true)
          $('.btn-view-all').click()
          expect('click').toHaveBeenTriggeredOn('.btn-view-all')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()

    describe "when not editable", ->
      beforeEach ->
        @eventsPartial.render(@options)

      describe "add button", ->
        it "Should not be displayed", ->
          expect(@eventsPartial.$el.find 'div').not.toHaveClass('btn-edit')

      describe "view all button", ->
        it "Should be displayed", ->
          expect(@eventsPartial.$el.find 'div').toHaveClass('btn-view-all')

        it "should navigate to view all screen", ->
          spyEvent = spyOnEvent('.btn-view-all', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/events', trigger: true)
          $('.btn-view-all').click()
          expect('click').toHaveBeenTriggeredOn('.btn-view-all')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()


