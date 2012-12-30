describe "CPP Tag Editor", ->
  beforeEach ->
    setFixtures(sandbox id: "tags")

    @model = new Backbone.Model {list: []}
    @callback = new sinon.stub()

    @tagEditor = new Backbone.Form.editors.TagEditor
      model: @model
      key: 'list'
      title: 'List'
      url: '/tags/list'
      tag_class: 'label-success'
      tag_change_callback: @callback
      additions: true
      el: "#tags"

  describe "initialize", ->
    it "should not yet have any tags", ->
      expect(@tagEditor.tags.length).toBe 0

  describe "render", ->
    beforeEach ->
      @tagEditor.render()

    it "should create a header", ->
      expect(@tagEditor.$el).toContain('.tag-category-header')

    it "should have an input", ->
      expect(@tagEditor.$el).toContain('.tag-input')
      expect(@tagEditor.$el.find('.tag-input')).toHaveAttr('type', 'text')

    it "should create a tags list", ->
      expect(@tagEditor.$el).toContain('.tageditor')

    it "should render tags in tags", ->
      @tagEditor.tags.push("new")
      @tagEditor.render()

      expect(@tagEditor.$el).toContain('.label-success')
      expect(@tagEditor.$el.find('.label-success').length).toBe 1

      expect(@tagEditor.$el).toContain('.tag-text')
      expect(@tagEditor.$el.find('.tag-text')).toHaveText('new')
      expect($('<a>some text</a>')).toHaveText('some text')

      expect(@tagEditor.$el.find('.remove-tag')).toHaveText('×')

  describe "input", ->
    beforeEach ->
      @tagEditor.render()

    it "should trigger input keypress on keypress", ->
      spy = spyOnEvent('input', 'keypress')
      @tagEditor.$el.find('input').keypress()
      expect('keypress').toHaveBeenTriggeredOn('input')
      expect(spy).toHaveBeenTriggered();

    describe "should add tag when keypress", ->
      beforeEach ->
        @tag = "new"
        @tagEditor.$input.val(@tag)
        @e = jQuery.Event "keypress"
        @spy = spyOnEvent 'input', 'keypress'

        sinon.stub(jQuery, "ajax").yieldsTo "success"

      it "is 44", ->
        @e.charCode = 44 # Some key code value

      it "is 13", ->
        @e.charCode = 13

      afterEach ->
        @tagEditor.$el.find('input').trigger(@e)
        expect('keypress').toHaveBeenTriggeredOn('input')
        expect(@spy).toHaveBeenTriggered()

        expect(@tagEditor.tags).toContain @tag
        expect(@model.get "list").toContain @tag

        expect(@callback).toHaveBeenCalledOnce()

        jQuery.ajax.restore()

  describe "remove", ->
    beforeEach ->
      @tagEditor.addTag t for t in ['a', 'b', 'c']
      @tagEditor.render()


    it "should trigger removal on remove-tag click", ->
      spy = spyOnEvent('.remove-tag', 'click')
      @tagEditor.$el.find('.remove-tag').click()
      expect('click').toHaveBeenTriggeredOn('.remove-tag')
      expect(spy).toHaveBeenTriggered();

    it "should remove tag on click", ->
      tag = @tagEditor.$el.find('.tag')[0]
      val = $(tag).find('.tag-text').text()

      $(tag).find('.remove-tag').click()

      expect(@tagEditor.tags).not.toContain(val)
      expect(@model.get 'list').not.toContain(val)
