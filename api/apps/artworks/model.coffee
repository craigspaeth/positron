#
# Library of retrieval, persistance, validation, json view, and domain logic
# for the "artworks" resource. Positron artworks are a compilation of Gravity
# artworks, their related data such as their artist and partner, and helpful
# data like their image url curies resolved.
#
# e.g.
# {
#   artwork: { id: '', title: '', _links: [] }
#   artists: [{ id: '', name: '', _links: [] }]
#   partner: { id: '', name: '', _links: [] }
#   image_urls: { large: 'http://stagic.artsy.net/images/1/large.jpg' }
# }
#

_ = require 'underscore'
async = require 'async'
request = require 'superagent'
{ ObjectId } = require 'mongojs'
{ ARTSY_URL, FUSION_URL } = process.env
{ imageUrlsFor, findByIds, searchToSlugs } = require '../../lib/artsy_model'

#
# Retrieval
#
@findByIds = (ids, callback) ->
  return callback [] unless ids?.length
  async.map ids, (id, cb) ->
    request.get("#{FUSION_URL}/api/v1/artworks/#{id}").end (err, res) ->
      cb err, res.body
  , (err, results) ->
    callback err, results

@search = (query, accessToken, callback) ->
  searchToSlugs 'Artwork', query, accessToken, (err, slugs) =>
    return callback err if err
    @findByIds slugs, callback
