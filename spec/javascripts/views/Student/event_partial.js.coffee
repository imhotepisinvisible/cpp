describe "EventsPartial", ->
  beforeEach ->
    setFixtures(sandbox id: "events")
    @event = new (Backbone.Model.extend
                start_date: '2011-10-10T14:48:00'
                id: 1
                title: "Foo")()

    @eventsPartialItem = new CPP.Views.EventsPartialItem
                              el: "#events"
                              model: @event


  describe "Partial Item", ->
    it "Should link to event on events page", ->
      @options = {editable: false}
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find('a')).toHaveAttr('href', '#events/1')

    it "Should display edit button if editable", ->
      @options = {editable: true}
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find 'div').toHaveClass('btn-edit')

    it "Shouldn't display edit button if not editable", ->
      @options = {editable: false}
      @eventsPartialItem.render(@options)
      expect(@eventsPartialItem.$el.find 'div').not.toHaveClass('btn-edit')
