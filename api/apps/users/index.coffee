express = require 'express'
routes = require './routes'
{ loginRequired } = require '../../lib/middleware'

app = module.exports = express()
app.set 'views', __dirname
app.set 'view engine', 'jade'

app.get '/v1/users*.html', routes.doc
app.get '/v1/users/me', loginRequired, routes.me