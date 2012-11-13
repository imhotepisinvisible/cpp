describe "Events Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: "events")
    @event = new Backbone.Model id: 1
    eventStub = sinon.stub(@event, 'get')
    eventStub.withArgs('start_date').returns('2011-10-10T14:48:00')
    eventStub.withArgs('title').returns('Foo')

    @eventsPartialItem = new CPP.Views.EventsPartialItem
                              el: "#events"
                              model: @event

    # Uneditable by default for tests
    @options = {editable: false}


  describe "Partial Item", ->
    it "Should link to event on events page", ->
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find('a')).toHaveAttr('href', '#events/1')

  describe "edit button", ->
    describe "when editable", ->
      beforeEach ->
        @options.editable = true
        @eventsPartialItem.render(@options)

      it "Should display edit button", ->
        expect(@eventsPartialItem.$el.find 'div').toHaveClass('btn-edit')

      it "should navigate to edit screen", ->
        spyEvent = spyOnEvent('#edit-button', 'click');
        navigationStub = sinon.spy(Backbone.history, 'navigate')
                            .withArgs('events/1/edit', trigger: true)
        $('#edit-button').click()
        expect('click').toHaveBeenTriggeredOn('#edit-button')
        expect(spyEvent).toHaveBeenTriggered()
        expect(navigationStub).toHaveBeenCalledOnce()
        Backbone.history.navigate.restore()

    describe "when not editable", ->
      it "Should not display edit button", ->
        @eventsPartialItem.render(@options)
        expect(@eventsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')


