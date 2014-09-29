{ present } = User = require './transaction_script'
{ API_URL } = process.env

@me = (req, res, next) ->
  res.send present req.user

@deleteMe = (req, res, next) ->
  User.destroyFromAccessToken req.get('X-Access-Token'), (err, user) ->
    return next err if err
    res.send present user

@set = (req, res, next) ->
  return next() unless token = req.get('X-Access-Token')
  User.fromAccessToken token, (err, user) ->

    # Stop all further requests if we can't find a user from that access token
    return next err if err
    res.err(
      devMessage: 'An X-Access-Token header with a valid Artsy API token is required'
      moreInfo: API_URL
    ) unless user?

    # Alias on the request object
    req.user = user

    # If `me` is passed as a value for any params, replace it with the
    # current user's id to transparently allow routes like
    # `/api/posts?author_id=me` or `/api/users/me`
    for set in ['params', 'body', 'query']
      for key, val of req[set]
        req[set][key] = user.id if val is 'me'

    next()