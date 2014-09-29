_ = require 'underscore'
Articles = require '../../collections/articles.coffee'

@articles = (req, res, next) ->
  res.render 'index', articles: []