fs = require 'fs'
path = require 'path'
env = require 'node-env-file'
env envFile if fs.existsSync envFile = path.resolve __dirname, '../.env'
express = require "express"
bodyParser = require 'body-parser'
users = require './resources/users/routes'
posts = require './resources/posts/routes'
morgan = require 'morgan'
{ helpers, notFound, locals, setUser, errorHandler,
  loginRequired } = require './lib/middleware'

app = module.exports = express()

# Middleware
app.use helpers
app.use bodyParser.urlencoded()
app.use bodyParser.json()
app.use morgan(
  if process.env.NODE_ENV is 'development' then 'dev' else 'combined'
)

# Users
app.delete '/users/me', users.deleteMe
app.use users.set
app.get '/users/me', users.me

# Posts
app.get '/posts', posts.index
app.get '/posts/:id', posts.find, posts.get
app.post '/posts', posts.post
app.put '/posts/:id', posts.find, posts.put
app.delete '/posts/:id', posts.find, posts.delete

# Moar middleware
app.use errorHandler
app.use notFound