class CPP.Models.AuditItem extends CPP.Models.Base
  initialize: ->

  typeToClass: ->
    switch @get('type')
      when 'company'    then 'icon-briefcase'
      when 'student'    then 'icon-user'
      when 'placement'  then 'icon-folder-open'
      when 'event'      then 'icon-calendar'
      when 'email'      then 'icon-envelope'
      else 'icon-circle'

class CPP.Collections.AuditItems extends CPP.Collections.Base
  url: '/audit_items'
  model: CPP.Models.AuditItem
  comparator: (audit_item) ->
    audit_item.get("timestamp")
