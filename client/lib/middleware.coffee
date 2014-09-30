#
# Add project-wide middelware. As this grows we'll want to break it up into
# sub-modules in /lib/middleware, /lib/locals, etc.
#

viewHelpers = require './view_helpers'

@locals = (req, res, next) ->
  res.locals.sd.URL = req.url
  res.locals.sd.USER = req.user?.toJSON()
  res.locals.user = req.user
  res.locals[key] = helper for key, helper of viewHelpers
  next()

# TODO: Refactor into a small app that renders an error page.
@errorHandler = (err, req, res, next) ->
  console.log 'ERROR ' + err
  res.status(err.status).send err.body?.user_message or err.message or err.toString()