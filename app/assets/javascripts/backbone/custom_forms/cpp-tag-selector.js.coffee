# Tag form editor
class Backbone.Form.editors.TagEditor extends Backbone.Form.editors.Base
  tags: []

  tagName: 'div'

  # Bind events
  events:
    'click .tag .remove-tag' : 'onRemoveTagClick'
    'keypress input' : 'onInputKeypress'

  # Set tag properties
  initialize: (options) =>
    super(options)

    if options.url? and options.url?
      @autocomplete_url = options.url
    else
      throw "Tag Editor Requires an Auto Complete URL"

    @validation_url = "/tags/validate"
    if options.validation_url? and options.validation_url?
      @validation_url = options.validation_url

    @title = ""
    if options.title?
      @title = options.title

    @tag_class = ""
    if options.tag_class?
      @tag_class = options.tag_class

    @additions = false
    if options.additions?
      @additions = options.additions

    @tag_change_callback = ->
      return
    if options.tag_change_callback?
      @tag_change_callback = options.tag_change_callback

    @setValue(@value)

    @$tagsList = $('<div> </div>').addClass('tageditor').hide()
    @$input = $('<input type="text" placeholder="Type to Add"/>').attr('name', @getName()).addClass("input-medium pull-right")

    @id = @$el.attr('id')
    @name = @$el.attr('name')
    @$el.removeAttr('name').removeAttr('id')

  # Render tags and set typeahead
  render: =>
    @$el.html("")
    @$tagsList.attr('id', @id).attr('name', @name).show()
    @$tagsList.html @renderTags()
    @$input.addClass("tag-input")
    @$input.typeahead
      source: (query, process) =>
        $.get @autocomplete_url, {exclude_tags: @tags}, (data) ->
          process(data)
      updater: (item) =>
        item = @addTag item
        return item

    header = $("<div>#{@title}</div>").addClass('tag-category-header')
    header.append @$input
    header.append $("<div/>").addClass "clearfix"

    @$el.append header
    @$el.append @$tagsList

  # Event handlers
  onRemoveTagClick: (event) =>
    $tag = $(event.target).siblings('.tag-text')
    @removeTag($tag.text())

  # Submit tag, add it to tags
  onInputKeypress: (event) =>
    return unless @additions
    if event.charCode == 44 || event.charCode == 13 # , or <CR>
      event.preventDefault()

      tag = @$input.val()
      if @validation_url
        $.ajax
          url: @validation_url,
          dataType: 'json'
          type: "GET"
          data:
            tag: tag
          success: (data) =>
            @addTag tag
          error: (data) =>
            response = JSON.parse data.responseText
            # TODO: DRY This with Sarah's Student Edit Code
            # See https://github.com/PeterHamilton/cpp/issues/82
            if response
              messages = []
              for attr, errors of response
                messages.push errors.join(', ')

            if !messages
              msg = 'Error'
            else
              msg = messages.join(', ')
            notify("error", msg)
      else
        @addTag tag

  # Backbone form interface
  # Get tags
  getValue: =>
    @tags

  # Set tags
  setValue: (tags) =>
    if tags == "" or tags == null
      tags = []
    @tags = tags

  # Focus on tag input
  focus: ->
    if (this.hasFocus)
      return
    @$input.focus()

  # Blur tag input
  blur: ->
    if (!this.hasFocus)
      return
    @$input.blur()


  # Instance methods
  renderTags: =>
    _.map(@filteredTags(), @renderTag).join(' ')

  filteredTags: =>
    _.reject @tags, (tag) -> tag == ''

  # Render individual tag
  renderTag: (tag) =>
    "<span class=\"label tag #{@tag_class}\"><span class=\"tag-text\">#{tag}</span><a class=\"close remove-tag\">×</a></span>"

  # Remove tag and re-render
  removeTag: (tag) =>
    @tags = _.without(@tags, tag)
    @commit()
    @tag_change_callback()
    @render()

  # Add and render tag
  addTag: (tag) =>
    tag = tag.toLowerCase()
    if tag && !@hasTag(tag)
      @tags.push tag
      @commit()
      @tag_change_callback()
      @render()
      @$input.val('')
      @$input.focus()
      return ""
    else
      # ERROR HERE
      return tag

  # Check is the tag is present
  hasTag: (value) =>
    jQuery.inArray(value, @tags) >= 0
