describe "Email Partial Item", ->
  beforeEach ->
    @email = new Backbone.Model id: 1
    emailStub = sinon.stub(@email, "get")
    emailStub.withArgs('subject').returns 'Subject'
    emailStub.withArgs('created_at').returns new Date()
    emailStub.withArgs('updated_at').returns new Date()

    @emailsPartialItem = new CPP.Views.EmailsPartialItem
                              model: @email
                              editable: false
                              id: "partial"

  describe "Partial Item", ->
    it "Should link to email on events page", ->
      @emailsPartialItem.render()
      spyEvent = spyOnEvent(@emailsPartialItem.$el, 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('emails/1', trigger: true)

      @emailsPartialItem.$el.click()
      expect('click').toHaveBeenTriggeredOn(@emailsPartialItem.$el)
      expect(spyEvent).toHaveBeenTriggered()
      expect(navigationStub).toHaveBeenCalledOnce()
      Backbone.history.navigate.restore()

    it "Should display edit button if editable", ->
      @emailsPartialItem.editable = true
      @emailsPartialItem.render()
      expect(@emailsPartialItem.$el.find 'div').toHaveClass('btn-edit')

    it "Shouldn't display edit button if not editable", ->
      @emailsPartialItem.render()
      expect(@emailsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')

  describe "On edit click", ->
    it "should navigate to edit screen", ->
      @emailsPartialItem.editable = true
      @emailsPartialItem.render()
      spyEvent = spyOnEvent((@emailsPartialItem.$el.find '.btn-edit'), 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('emails/1/edit', trigger: true)
      $(@emailsPartialItem.$el.find '.btn-edit').click()
      expect('click').toHaveBeenTriggeredOn(@emailsPartialItem.$el.find '.btn-edit')
      expect(spyEvent).toHaveBeenTriggered()
      expect(navigationStub).toHaveBeenCalledOnce()
      Backbone.history.navigate.restore()


