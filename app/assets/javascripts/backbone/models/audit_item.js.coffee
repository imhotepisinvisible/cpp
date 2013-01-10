class CPP.Models.AuditItem extends Backbone.Model
  getIconClass: ->
    switch @get('type')
      when 'company'    then 'icon-briefcase'
      when 'student'    then 'icon-user'
      when 'placement'  then 'icon-folder-open'
      when 'event'      then 'icon-calendar'
      when 'email'      then 'icon-envelope'
      else 'icon-circle'

  getReadableTimestamp: ->
    Date.parse(@get('timestamp')).toString('dS MMMM yyyy - H:mm')

class CPP.Collections.AuditItems extends Backbone.Collection
  url: '/audit_items'
  model: CPP.Models.AuditItem
