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

    # Uneditable by default for tests
    @options = {editable: false}


  describe "Partial Item", ->
    it "Should link to event on events page", ->
      @placementsPartialItem.render(@options)
      expect(@placementsPartialItem.$el.find('a')).toHaveAttr('href', '#placements/1')

    it "Should display edit button if editable", ->
      @options.editable = true
      @placementsPartialItem.render(@options)
      expect(@placementsPartialItem.$el.find 'div').toHaveClass('btn-edit')

    it "Shouldn't display edit button if not editable", ->
      @placementsPartialItem.render(@options)
      expect(@placementsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')
