describe "Email Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: "emails")
    @email = new Backbone.Model id: 1
    emailStub = sinon.stub(@email, "get")
    emailStub.withArgs('subject').returns 'Subject'
    emailStub.withArgs('created_at').returns new Date()
    emailStub.withArgs('updated_at').returns new Date()

    @eventsPartialItem = new CPP.Views.EmailsPartialItem
                              el: "#emails"
                              model: @email

    # Uneditable by default for tests
    @options = {editable: false}


  describe "Partial Item", ->
    it "Should link to email on events page", ->
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find('a')).toHaveAttr('href', '#emails/1')

    it "Should display edit button if editable", ->
      @options.editable = true
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find 'div').toHaveClass('btn-edit')

    it "Shouldn't display edit button if not editable", ->
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')

  describe "On edit click", ->
    it "should navigate to edit screen", ->
      @options.editable = true
      @eventsPartialItem.render(@options)
      spyEvent = spyOnEvent('#edit-button', 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('emails/1/edit', trigger: true)
      $('#edit-button').click()
      expect('click').toHaveBeenTriggeredOn('#edit-button')
      expect(spyEvent).toHaveBeenTriggered()
      expect(navigationStub).toHaveBeenCalledOnce()



