_ = require 'underscore'
qs = require 'querystring'
{ present, presentCollection } = Post = require './transaction_script'
{ API_URL } = process.env

@find = (req, res, next) ->
  Post.find req.params.id, (err, post) ->
    return next err if err
    return res.err(
      status: 404
      devMessage: 'Resource not found.'
      userMessage: "Could not find post."
    ) if !post? or (!post.published and post.author_id isnt req.user?.id)
    req.post = post
    next()

@index = (req, res, next) ->
  unless req.user?.details.type is 'Admin'
    return res.err(
      status: 401
      devMessage: 'Must specify published=&author_id=.'
      userMessage: "Access Denied."
    ) if (!req.param('author_id')? and req.param('published') isnt 'true')
    return res.err(
      status: 401
      devMessage: "author_id does not match your id"
      userMessage: "Access Denied."
    ) if req.param('author_id')? and req.param('published') isnt 'true' and
         req.param('author_id') isnt req.user?.id
  Post.all req.query, (err, total, count, posts) ->
    return next err if err
    res.send presentCollection total, count, posts

@get = (req, res, next) ->
  res.send present req.post

@post = (req, res, next) ->
  Post.save _.extend(req.body, author_id: req.user.id), (err, post) ->
    return next err if err
    res.send present post

@put = (req, res, next) ->
  return res.err(
    status: 401
    devMessage: "Can not update another user's post."
    userMessage: "Access denied."
  ) if req.post.author_id isnt req.user?.id
  return res.err(
    status: 401
    devMessage: "Only admins can change the author of a post."
    userMessage: "Access denied."
  ) if req.body.author_id and req.user?.type isnt 'Admin'
  Post.save _.extend(req.post, req.body), (err, post) ->
    return next err if err
    res.send present post

@delete = (req, res, next) ->
  Post.destroy req.post._id, (err) ->
    return next err if err
    res.send present req.post