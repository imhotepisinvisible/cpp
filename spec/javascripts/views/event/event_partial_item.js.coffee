describe "Events Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: "events")
    @event = new Backbone.Model id: 1
    eventStub = sinon.stub(@event, 'get')
    eventStub.withArgs('start_date').returns('2011-10-10T14:48:00')
    eventStub.withArgs('title').returns('Foo')

    @partialItem = new CPP.Views.Events.PartialItem
                              el: "#events"
                              model: @event
                              editable: false

  describe "Partial Item", ->
    it "Should link to event on events page", ->
      @partialItem.render()
      expect(@partialItem.$el.find('a')).toHaveAttr('href', '#events/1')

  describe "edit button", ->
    describe "when editable", ->
      beforeEach ->
        @partialItem.editable = true
        @partialItem.render()

      it "Should display edit button", ->
        expect(@partialItem.$el.find 'div').toHaveClass('btn-edit')

      it "should navigate to edit screen", ->
        spyEvent = spyOnEvent('.btn-edit', 'click');
        navigationStub = sinon.spy(Backbone.history, 'navigate')
                            .withArgs('events/1/edit', trigger: true)
        $('.btn-edit').click()
        expect('click').toHaveBeenTriggeredOn('.btn-edit')
        expect(spyEvent).toHaveBeenTriggered()
        expect(navigationStub).toHaveBeenCalledOnce()
        Backbone.history.navigate.restore()

    describe "when not editable", ->
      it "Should not display edit button", ->
        @partialItem.render()
        expect(@partialItem.$el.find 'div').not.toHaveClass('btn-edit')


