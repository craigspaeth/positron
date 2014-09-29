#
# Generic api-wide middleware. As this grows we'll want to break it up into
# sub-modules in /lib/middleware, etc.
#

UNKNOWN_ERROR = "Unknown failure. " +
                "Try again or contact support@artsymail.com for help."
User = require '../apps/users/transaction_script'
{ parse } = require 'url'
{ API_URL } = process.env

@helpers = (req, res, next) ->

  # Error handler helper for predictable JSON responses.
  res.err = (options = {}) ->
    err =
      status: status = options.status or 500
      dev_message: options.devMessage or "Internal Error"
      user_message: options.userMessage or UNKNOWN_ERROR
      more_info: options.moreInfo or API_URL
    res.status(status).send err
  next()

@locals = (req, res, next) ->
  res.locals.API_URL = API_URL
  res.locals.API_PATH = parse(API_URL).path
  res.locals.PATH = req.url
  res.locals.user = req.user
  next()

@notFound = (req, res, next) ->
  res.err
    status: 404
    devMessage: "Endpoint does not exist."
    userMessage: "Not found."
    moreInfo: API_URL

@setUser = (req, res, next) ->
  return next() unless token = req.get('X-Access-Token') or req.param('access_token')
  User.fromAccessToken token, (err, user) ->
    return next err if err
    res.locals.user = req.user = user
    next()

@loginRequired = (req, res, next) ->
  return next() if req.user?
  res.err(
    devMessage: 'An X-Access-Token header with a valid Artsy API token is required'
    moreInfo: API_URL
  )

@errorHandler = (err, req, res, next) ->
  console.log err.stack
  res.err
    status: err.status
    devMessage: err.message or err.toString() + err.stack