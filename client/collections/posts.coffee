sd = require('sharify').data
Backbone = require 'backbone'
Post = require '../models/post.coffee'

module.exports = class Posts extends Backbone.Collection

  url: "#{sd.API_URL}/posts"

  model: Post

  parse: (data) ->
    { @count, @total } = data
    data.results