describe "Placement Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: "placements")
    @placement = new Backbone.Model id: 1

    placementStub = sinon.stub(@placement, 'get')
    placementStub.withArgs('position').returns('Intern')
    placementStub.withArgs('description').returns('Awesome backend job')

    @placementsPartialItem = new CPP.Views.PlacementsPartialItem
                              el: "#placements"
                              model: @placement
                              editable: false

  describe "Partial Item", ->
    it "Should link to event on events page", ->
      @placementsPartialItem.render(@options)
      expect(@placementsPartialItem.$el.find('a')).toHaveAttr('href', '#placements/1')


  describe "edit button", ->
    describe "when editable", ->
      beforeEach ->
        @placementsPartialItem.editable = true
        @placementsPartialItem.render(@options)

      it "Should display edit button", ->
        expect(@placementsPartialItem.$el.find 'div').toHaveClass('btn-edit')

      it "should navigate to edit screen", ->
        spyEvent = spyOnEvent('#edit-button', 'click');
        navigationStub = sinon.spy(Backbone.history, 'navigate')
                            .withArgs('placements/1/edit', trigger: true)
        $('#edit-button').click()
        expect('click').toHaveBeenTriggeredOn('#edit-button')
        expect(spyEvent).toHaveBeenTriggered()
        expect(navigationStub).toHaveBeenCalledOnce()
        Backbone.history.navigate.restore()

    describe "when not editable", ->
      it "Should not display edit button", ->
        @placementsPartialItem.render(@options)
        expect(@placementsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')


