#
# Generic api-wide middleware. As this grows we'll want to break it up into
# sub-modules in /lib/middleware, etc.
#

_ = require 'underscore'
{ parse } = require 'url'
{ API_URL } = process.env

UNKNOWN_ERROR = "Unknown failure. " +
                "Try again or contact support@artsymail.com for help."

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

@notFound = (req, res, next) ->
  res.err
    status: 404
    devMessage: "Endpoint does not exist."
    userMessage: "Not found."
    moreInfo: API_URL

@errorHandler = (err, req, res, next) ->
  console.log err.stack
  res.err
    status: err.status
    devMessage: err.message or err.toString()