describe "Placement Partial Item", ->
  beforeEach ->
    setFixtures(sandbox id: "placements")
    @placement = new Backbone.Model id: 1

    placementStub = sinon.stub(@placement, 'get')
    placementStub.withArgs('position').returns('Intern')
    placementStub.withArgs('description').returns('Awesome backend job')

    @placementsPartialItem = new CPP.Views.Placements.PartialItem
                              el: "#placements"
                              model: @placement
                              editable: false

  describe "Partial Item", ->
    it "Should link to event on events page", ->
      console.log "oplacement item", $('.placement-item')
      spyEvent = spyOnEvent('.placement-item', 'click');
      navigationStub = sinon.spy(Backbone.history, 'navigate')
                          .withArgs('placements/1', trigger: true)
      $('.placement-item').click()
      expect('click').toHaveBeenTriggeredOn('.placement-item')
      expect(spyEvent).toHaveBeenTriggered()
      expect(navigationStub).toHaveBeenCalledOnce()
      Backbone.history.navigate.restore()


  describe "edit button", ->
    describe "when editable", ->
      beforeEach ->
        @placementsPartialItem.editable = true
        @placementsPartialItem.render(@options)

      it "Should display edit button", ->
        expect(@placementsPartialItem.$el.find 'div').toHaveClass('btn-edit')

      it "should navigate to edit screen", ->
        spyEvent = spyOnEvent('.btn-edit', 'click');
        navigationStub = sinon.spy(Backbone.history, 'navigate')
                            .withArgs('placements/1/edit', trigger: true)
        $('.btn-edit').click()
        expect('click').toHaveBeenTriggeredOn('.btn-edit')
        expect(spyEvent).toHaveBeenTriggered()
        expect(navigationStub).toHaveBeenCalledOnce()
        Backbone.history.navigate.restore()

    describe "when not editable", ->
      it "Should not display edit button", ->
        @placementsPartialItem.render(@options)
        expect(@placementsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')


