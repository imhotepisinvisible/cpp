describe "Email Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: "email")
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
      $("#email").append @emailsPartialItem.render().$el
      spyEvent = spyOnEvent("#partial", 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('emails/1', trigger: true)

      $("#partial").click()
      expect('click').toHaveBeenTriggeredOn("#partial")
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
      $("#email").append @emailsPartialItem.render().$el
      spyEvent = spyOnEvent('.btn-edit', 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('emails/1/edit', trigger: true)
      $('.btn-edit').click()
      expect('click').toHaveBeenTriggeredOn('.btn-edit')
      expect(spyEvent).toHaveBeenTriggered()
      expect(navigationStub).toHaveBeenCalledOnce()
      Backbone.history.navigate.restore()


