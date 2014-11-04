_ = require 'underscore'
Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Article extends Backbone.Model

  defaults:
    sections: []

  urlRoot: "#{sd.API_URL}/articles"

  stateName: ->
    if @get('published') then 'Article' else 'Draft'

  finishedContent: ->
    @get('title')?.length > 0

  finishedThumbnail: ->
    @get('thumbnail_title')?.length > 0 and
    @get('thumbnail_image')?.length > 0 and
    @get('thumbnail_teaser')?.length > 0 and
    @get('tags')?.length > 0