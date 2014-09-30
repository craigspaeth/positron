Backbone = require 'backbone'
request = require 'superagent'
sd = require('sharify').data

module.exports = class CurrentUser extends Backbone.Model

  url: "#{sd.API_URL}/users/me"

  sync: (method, model, options) ->
    options.headers ?= {}
    options.headers['X-Access-Token'] = @get 'access_token'
    Backbone.sync.call this, method, model, options