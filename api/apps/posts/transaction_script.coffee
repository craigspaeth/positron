#
# Transaction script for the posts collection.
# http://martinfowler.com/eaaCatalog/transactionScript.html
#

_ = require 'underscore'
db = require '../../lib/db'
async = require 'async'
Joi = require 'joi'
moment = require 'moment'
{ ObjectId } = require 'mongojs'

schema = (->
  title: @string()
  teaser: @string()
  thumbnail: @string()
  tags: @array().includes(@string())
  content_title: @string()
  preamble: @string()
  author_id: @string()
  published: @boolean().default(false)
  sections: @array().includes [
    @object().keys
      type: @string().valid('image')
      url: @string()
    @object().keys
      type: @string().valid('text')
      body: @string()
    @object().keys
      type: @string().valid('artworks')
      ids: @array().includes @string()
    @object().keys
      type: @string().valid('video')
      url: @string()
  ]
).call Joi

@all = (params, callback) ->
  query =
    published: JSON.parse(params.published) ? true
    author_id: params.author_id
  async.parallel [
    (cb) -> db.posts.count cb
    (cb) -> db.posts.count query, cb
    (cb) -> db.posts.find(query).toArray cb
  ], (err, results) ->
    return callback err if err
    callback null, results...

@find = (id, callback) ->
  db.posts.findOne { _id: ObjectId(id) }, (err, doc) ->
    return callback err if err
    callback null, doc

@save = (data, callback) ->
  id = ObjectId data._id
  delete data._id
  Joi.validate _.pick(data, _.keys schema), schema, (err, data) ->
    return callback err if err
    data.updated_at = moment().format()
    db.posts.update { _id: id }, data, { upsert: true }, (err) ->
      callback err, data

@destroy = (id, callback) ->
  db.posts.remove { _id: ObjectId(id) }, (err, res) ->
    console.log err, res
    callback err, res

@presentCollection = (total, count, data) =>
  {
    total: total
    count: count
    results: (@present(obj) for obj in data)
  }

@present = (data) ->
  d = {}
  d.id = data._id
  _.omit _.extend(d, data), '_id'