describe "Email Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: 'partial')
    @email = new Backbone.Model id: 1
    emailStub = sinon.stub(@email, "get")
    emailStub.withArgs('subject').returns 'Subject'
    emailStub.withArgs('created_at').returns new Date()
    emailStub.withArgs('updated_at').returns new Date()

    @emailsPartialItem = new CPP.Views.EmailsPartialItem
                              el: "#partial"
                              model: @email

    # Uneditable by default for tests
    @options = {editable: false}


  describe "Partial Item", ->
    it "Should link to email on events page", ->
        spyEvent = spyOnEvent('#partial', 'click');
        navigationStub = sinon.spy(Backbone.history, 'navigate')
                            .withArgs('emails/1', trigger: true)

        $('#partial').click()
        expect('click').toHaveBeenTriggeredOn('#partial')
        expect(spyEvent).toHaveBeenTriggered()
        expect(navigationStub).toHaveBeenCalledOnce()
        Backbone.history.navigate.restore()

    it "Should display edit button if editable", ->
      @options.editable = true
      @emailsPartialItem.render(@options)
      expect(@emailsPartialItem.$el.find 'div').toHaveClass('btn-edit')

    it "Shouldn't display edit button if not editable", ->
      @emailsPartialItem.render(@options)
      expect(@emailsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')

  describe "On edit click", ->
    it "should navigate to edit screen", ->
      @options.editable = true
      @emailsPartialItem.render(@options)
      spyEvent = spyOnEvent('#edit-button', 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('emails/1/edit', trigger: true)
      $('#edit-button').click()
      expect('click').toHaveBeenTriggeredOn('#edit-button')
      expect(spyEvent).toHaveBeenTriggered()
      expect(navigationStub).toHaveBeenCalledOnce()
      Backbone.history.navigate.restore()


