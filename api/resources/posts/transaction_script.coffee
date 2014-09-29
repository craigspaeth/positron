#
# Transaction script for the posts collection.
# http://martinfowler.com/eaaCatalog/transactionScript.html
#
# Example:
# {
#   id: '54276766fd4f50996aeca2b8'
#   title: 'Top Ten Booths',
#   teaser: 'Just before the lines start forming...',
#   thumbnail: 'http://kitten.com',
#   tags: ['Fair Coverage', 'Magazine']
#   content_title: 'Top Ten Booths at miart 2014',
#   preamble: 'Just before the lines start forming...',
#   author_id: '4d8cd73191a5c50ce200002a',
#   published: true,
#   published_at: '1994-11-05T08:15:30-05:00',
#   updated_at: '1994-11-05T08:15:30-05:00',
#   sections: [
#     {
#       type: 'image',
#       url: 'http://gemini.herokuapp.com/123/miaart-banner.jpg'
#     },
#     {
#       type: 'text',
#       body: '## 10. Lisson Gallery\nMia Bergeron merges the _personal_ and _universal_...',
#     },
#     {
#       type: 'artworks',
#       ids: ['5321b73dc9dc2458c4000196', '5321b71c275b24bcaa0001a5']
#     },
#     {
#       type: 'text',
#       body: 'Check out this video art:',
#     },
#     {
#       type: 'video',
#       url: 'http://youtu.be/yYjLrJRuMnY'
#     }
#   ]
# }

_ = require 'underscore'
db = require '../../lib/db'
async = require 'async'
Joi = require 'joi'
moment = require 'moment'
{ ObjectId } = require 'mongojs'

# Validations

schema = (->
  title: @string()
  teaser: @string()
  thumbnail: @string()
  tags: @array().includes(@string())
  content_title: @string()
  preamble: @string()
  author_id: @string().required()
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

querySchema = (->
  author_id: @string()
  published: @boolean()
).call Joi

# Retrieval

@all = (query = {}, callback) ->
  Joi.validate query, querySchema, (err, query) ->
    return callback err if err
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

# Persistence

@save = (data, callback) ->
  id = ObjectId data._id
  Joi.validate _.pick(data, _.keys schema), schema, (err, data) ->
    return callback err if err
    data.updated_at = moment().format()
    db.posts.update { _id: id }, data, { upsert: true }, (err) ->
      callback err, data

@destroy = (id, callback) ->
  db.posts.remove { _id: ObjectId(id) }, (err, res) ->
    callback err, res

# JSON views

@presentCollection = (total, count, data) =>
  {
    total: total
    count: count
    results: (@present(obj) for obj in data)
  }

@present = (data) ->
  post = {}
  post.id = data._id
  _.omit _.extend(post, data), '_id'