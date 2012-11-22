class Backbone.Form.editors.TagEditor extends Backbone.Form.editors.Base
  tags: []

  tagName: 'div'

  events:
    'click .tag .remove-tag' : 'onRemoveTagClick'

  initialize: (options) =>
    super(options)

    if options.url? and options.url?
      @autocomplete_url = options.url

    if options.title?
      @title = options.title

    @setValue(@value)


    @$tagsList = $('<div> </div>').addClass('tageditor').hide()
    @$input = $('<input type="text" placeholder="Type to Add"/>').attr('name', @getName()).addClass("input-medium pull-right")

    @id = @$el.attr('id')
    @name = @$el.attr('name')
    @$el.removeAttr('name').removeAttr('id')

  render: =>
    @$el.html("")
    @$tagsList.attr('id', @id).attr('name', @name).show()
    @$tagsList.html @renderTags()

    @$input.typeahead
      source: (query, process) =>
        $.get '/tags/skills', {exclude_tags: @tags}, (data) ->
          process(data)
      updater: (item) =>
        @$input.val('')
        item = @addTag item
        return item

    header = $("<div>#{@title}</div>").addClass('tag-category-header')
    header.append @$input
    header.append $("<div/>").addClass "clearfix"

    @$el.append header
    @$el.append @$tagsList

  # event handlers
  onRemoveTagClick: (event) =>
    $tag = $(event.target).siblings('.tag-text')
    @removeTag($tag.text())

  # onInputBlur: (event) =>
  #   return
  #   # return if @$suggestions.isSuggesting()
  #   # unless @$input.val() == ''
  #   #   @addTag @sanitizedInputValue()

  # onInputKeypress: (event) =>
  #   return
  #   # if event.charCode == 44 || event.charCode == 13 # , or <CR>
  #   #   @addTag @sanitizedInputValue()
  #   #   event.preventDefault()

  # onInputKeydown: (event) =>
  #   return
  #   # if @$input.val() == '' && event.keyCode == 8 # backspace
  #   #   @removeLastTag()

  # backbone form interface
  getValue: =>
    @tags

  setValue: (tags) =>
    @tags = tags

  focus: ->
    if (this.hasFocus)
      return
    @$input.focus()

  blur: ->
    if (!this.hasFocus)
      return
    @$input.blur()


  # instance methods
  renderTags: =>
    _.map(@filteredTags(), @renderTag).join(' ')

  filteredTags: =>
    _.reject @tags, (tag) -> tag == ''

  renderTag: (tag) =>
    "<span class=\"label tag skill-tag\"><span class=\"tag-text\">#{tag}</span><a class=\"close remove-tag\">×</a></span>"

  removeTag: (tag) =>
    @tags = _.without(@tags, tag)
    @commit()
    @saveModel()
    @render()

  addTag: (tag) =>
    if tag && !@hasTag(tag)
      @tags.push tag
      @commit()
      @saveModel()
      @render()
      return ""
    else
      # ERROR HERE
      return tag

  saveModel: ->
    @model.save {},
      wait: true
      success: (model, response) =>
        notify "success", "Updated Profile"
      error: (model, response) ->
        # Notify tag-specific errors here (profanity etc)
        errorlist = JSON.parse response.responseText
        notify "error", "Couldn't Update Profile"

  hasTag: (value) =>
    jQuery.inArray(value, @tags) >= 0
