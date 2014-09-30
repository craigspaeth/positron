sd = require('sharify').data
Backbone = require 'backbone'

module.exports = class Post extends Backbone.Model

  urlRoot: "#{sd.API_URL}/posts"