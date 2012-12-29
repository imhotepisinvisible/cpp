# This pulls in all your specs from the javascripts directory into Jasmine:
#
# spec/javascripts/*_spec.js.coffee
# spec/javascripts/*_spec.js
# spec/javascripts/*_spec.js.erb
# IT IS UNLIKELY THAT YOU WILL NEED TO CHANGE THIS FILE
#
#= require application
#= require sinon
#= require jasmine-sinon
#= require jasmine-jquery

#= require_tree ./collections
#= require_tree ./models
#= require_tree ./routing

#= require_tree ./views/email
#= require_tree ./views/event
#= require_tree ./views/placement
#= require_tree ./views/student
