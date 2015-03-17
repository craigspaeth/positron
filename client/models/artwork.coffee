_ = require 'underscore'
Backbone = require 'backbone'
sd = require('sharify').data

module.exports = class Artwork extends Backbone.Model

  truncatedLabel: ->
    split = @get('artists')[0].name.split ' '
    artistInitials = split[0][0] + '.' + split[1][0] + '.'
    artistInitials + ' ' + @get('artwork').title + ', ' + @get('artwork').date

  # TODO: Drop the orchestration layer stuff and just leverage v1 +
  # Artsy Backbone Mixins.
  imageUrl: ->
    @get('image_urls')?.large or
    @get('image_urls')?[_.keys(@get 'image_urls')?[0]] or
    "/images/grey_box.png"