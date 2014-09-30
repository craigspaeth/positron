_ = require 'underscore'
Posts = require '../../collections/posts.coffee'

@posts = (req, res, next) ->
  new Posts().fetch
    headers: { 'X-Access-Token': req.user.get('access_token') }
    data: { author_id: 'me', published: req.query.published }
    error: (m, r) -> next r
    success: (posts) ->
      res.locals.sd.POSTS = posts.toJSON()
      res.render 'index', posts: posts.models