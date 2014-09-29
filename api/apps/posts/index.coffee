express = require 'express'
routes = require './routes'
{ loginRequired } = require '../../lib/middleware'

app = module.exports = express()
app.set 'views', __dirname
app.set 'view engine', 'jade'

app.get '/v1/posts*.html', routes.doc
app.get '/v1/posts', routes.index
app.get '/v1/posts/:id', routes.findPost, routes.get
app.post '/v1/posts', loginRequired, routes.post
app.put '/v1/posts/:id', loginRequired, routes.findPost, routes.put
app.delete '/v1/posts/:id', loginRequired, routes.findPost, routes.delete