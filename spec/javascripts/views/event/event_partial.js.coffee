describe "Events partial", ->
  beforeEach ->
    setFixtures(sandbox id: "events")
    @event = new Backbone.Model id: 1
    @company = new Backbone.Model id: 1

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
      @partialStub.reset()
      for id in [1..4]
        do (id) =>
          @collection.add new Backbone.Model id: id

      @eventsPartial.render()
      expect(@partialStub).toHaveBeenCalledThrice()

  describe "buttons", ->
    describe "when editable", ->
      beforeEach ->
        @eventsPartial.editable = true

      describe "for specific company", ->
        beforeEach ->
          @eventsPartial.company = @company
          @eventsPartial.render()

          describe "add button", ->
            it "should be displayed", ->
              expect(@eventsPartial.$el).toContain('.button-add-event')

            it "should link to add an event for a specific company", ->
              expect(@eventsPartial.$el.find('.button-add-event'))
                .toHaveAttr('href', "#/companies/#{@company.get('id')}/events/new")

          describe "view all button", ->
            it "should be displayed", ->
              expect(@eventsPartial.$el).toContain('.button-all-events')

            it "should link to events for a specific company", ->
              expect(@eventsPartial.$el.find('.button-all-events'))
                .toHaveAttr('href', "#/companies/#{@company.get('id')}/events")

      describe "for a general event list", ->
        beforeEach ->
          @eventsPartial.render()

        describe "add button", ->
          it "should be displayed", ->
            expect(@eventsPartial.$el).toContain('.button-add-event')

          it "should link to add a general event", ->
            expect(@eventsPartial.$el.find('.button-add-event'))
              .toHaveAttr('href', '#/events/new')

        describe "view all button", ->
          it "should be displayed", ->
            expect(@eventsPartial.$el).toContain('.button-all-events')

          it "should link to general events", ->
            expect(@eventsPartial.$el.find('.button-all-events'))
              .toHaveAttr('href', '#/events')

    describe "when not editable", ->
      beforeEach ->
        @eventsPartial.editable = false

      describe "for specific company", ->
        beforeEach ->
          @eventsPartial.company = @company
          @eventsPartial.render()

        describe "add button", ->
          it "should not be displayed", ->
            expect(@eventsPartial.$el).not.toContain('.button-add-event')

        describe "view all button", ->
          it "should be displayed", ->
            expect(@eventsPartial.$el).toContain('.button-all-events')

          it "should link to events for a specific company", ->
            expect(@eventsPartial.$el.find('.button-all-events'))
              .toHaveAttr('href', "#/companies/#{@company.get('id')}/events")

      describe "for a general event list", ->
        beforeEach ->
          @eventsPartial.render()

        describe "add button", ->
          it "should not be displayed", ->
            expect(@eventsPartial.$el).not.toContain('.button-add-event')

        describe "view all button", ->
          it "should be displayed", ->
            expect(@eventsPartial.$el).toContain('.button-all-events')

          it "should link to general events", ->
            expect(@eventsPartial.$el.find('.button-all-events'))
              .toHaveAttr('href', '#/events')
