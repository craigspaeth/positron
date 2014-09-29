_ = require 'underscore'
{ present, presentCollection } = Post = require './transaction_script'
{ API_URL } = process.env

@doc = (req, res) ->
  res.render 'doc'

@findPost = (req, res, next) ->
  Post.find req.params.id, (err, post) ->
    return next err if err
    return res.err(
      status: 404
      devMessage: 'Resource not found.'
      userMessage: "Could not find post."
    ) if not post?
    req.post = post
    next()

@index = (req, res, next) ->
  q = _.extend { published: false }, req.query
  Post.all q, (err, total, count, posts) ->
    res.send presentCollection total, count, posts

@get = (req, res, next) ->
  return res.err(
    status: 404
    devMessage: 'Resource not found.'
    userMessage: "Could not find post."
  ) if (not req.post.published and req.user?.id isnt post.author_id)
  res.send present req.post

@post = (req, res, next) ->
  data = req.body
  data.author_id = req.user.id
  Post.save data, (err, post) ->
    return next err if err
    res.send present post

@put = (req, res, next) ->
  return res.err(
    status: 401
    devMessage: "Can not update another user's post."
    userMessage: "Access denied."
  ) if req.post.author_id isnt req.user.id
  return res.err(
    status: 401
    devMessage: "Only admins can change the author of a post."
    userMessage: "Access denied."
  ) if req.body.author_id and req.user.type isnt 'Admin'
  Post.save _.extend(req.post, req.body), (err, post) ->
    return next err if err
    res.send present post

@delete = (req, res, next) ->
  Post.destroy req.post._id, (err) ->
    return next err if err
    res.send present req.post