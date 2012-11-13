describe "EventsPartial", ->
  beforeEach ->
    setFixtures(sandbox id: "placements")
    @event = new (Backbone.Model.extend
                position: 'Intern'
                id: 1
                description: 'Awesome backend job')()

    @placementsPartialItem = new CPP.Views.PlacementsPartialItem
                              el: "#placements"
                              model: @event

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
