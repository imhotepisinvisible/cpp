$ ->
  console.log "Custom templates"
  Backbone.Form.setTemplates
    # form: '
    #   <form class="form-horizontal">{{fieldsets}}</form>
    # '

    # fieldset: '
    #   <fieldset>
    #     <legend>{{legend}}</legend>
    #     {{fields}}
    #   </fieldset>
    # '

    field: '
      <div class="control-group field-{{key}}">
        <label class="control-label" for="{{id}}">{{title}}</label>
        <div class="controls">
          {{editor}}
          <span class="help-inline">{{help}}</span>
        </div>
      </div>
    '

    # nestedField: '
    #   <div class="field-{{key}}">
    #     <div title="{{title}}" class="input-xlarge">{{editor}}</div>
    #     <span class="help-inline">{{help}}</span>
    #   </div>
    # '

    # list: '
    #   <div class="bbf-list">
    #     <ul class="unstyled clearfix">{{items}}</ul>
    #     <button type="button" class="btn bbf-add" data-action="add">Add</div>
    #   </div>
    # '

    # listItem: '
    #   <li class="clearfix">
    #     <div class="pull-left">{{editor}}</div>
    #     <button type="button" class="btn bbf-del" data-action="remove">&times;</button>
    #   </li>
    # '

    date: '
        <input type="text" data-behaviour="datepicker"/>
    '

    dateTime: '
      <div class="bbf-datetime">
          {{date}}
          &nbsp;&nbsp;
          <select data-type="hour" style="width: 4em">{{hours}}</select>
          :
          <select data-type="min" style="width: 4em">{{mins}}</select>
      </div>
    '
