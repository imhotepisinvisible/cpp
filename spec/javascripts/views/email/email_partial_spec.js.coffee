describe "Emails Partial", ->
  beforeEach ->
    setFixtures(sandbox id: "events")
    @event = new Backbone.Model id: 1

    @model = new Backbone.Model()
    @collection = new Backbone.Collection()
    @collection.add @model

    @partialView = new Backbone.View()
    @partialView.el = '<div "id=item"></div>'

    @partialStub = sinon.stub(window.CPP.Views.TaggedEmails, "PartialItem")
                      .returns(@partialView)


    @emailsPartial = new CPP.Views.TaggedEmails.PartialItem
                              el: "#events"
                              model: @event
                              collection: @collection

  afterEach ->
    window.CPP.Views.TaggedEmails.PartialItem.restore()

  describe "initialize", ->
    it "should have editable attribute default to false", ->
      expect(@emailsPartial.editable).toBeFalsy()

  describe "render", ->
    it "should return itself", ->
      expect(@emailsPartial.render()).toBe(@emailsPartial)

  describe "buttons", ->
    describe "when editable", ->
      beforeEach ->
        @emailsPartial.editable = true
        @emailsPartial.render()

      describe "add button", ->
        it "Should be displayed", ->
          expect(@emailsPartial.$el.find 'div').toHaveClass('btn-add')

        it "should navigate to add screen when clicked", ->
          spyEvent = spyOnEvent('.btn-add', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/emails/new', trigger: true)
          $('.btn-add').click()
          expect('click').toHaveBeenTriggeredOn('.btn-add')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()

      describe "view all button", ->
        it "Should be displayed", ->
          expect(@emailsPartial.$el.find 'div').toHaveClass('btn-view-all')

        it "should navigate to view all screen", ->
          spyEvent = spyOnEvent('.btn-view-all', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/emails', trigger: true)
          $('.btn-view-all').click()
          expect('click').toHaveBeenTriggeredOn('.btn-view-all')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()

    describe "when not editable", ->
      beforeEach ->
        @emailsPartial.render(@options)

      describe "add button", ->
        it "Should not be displayed", ->
          expect(@emailsPartial.$el.find 'div').not.toHaveClass('btn-edit')

      describe "view all button", ->
        it "Should be displayed", ->
          expect(@emailsPartial.$el.find 'div').toHaveClass('btn-view-all')

        it "should navigate to view all screen", ->
          spyEvent = spyOnEvent('.btn-view-all', 'click');
          navigationStub = sinon.spy(Backbone.history, 'navigate')
                              .withArgs('companies/1/emails', trigger: true)
          $('.btn-view-all').click()
          expect('click').toHaveBeenTriggeredOn('.btn-view-all')
          expect(spyEvent).toHaveBeenTriggered()
          expect(navigationStub).toHaveBeenCalledOnce()
          Backbone.history.navigate.restore()


