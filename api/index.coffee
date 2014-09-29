fs = require 'fs'
path = require 'path'
env = require 'node-env-file'
env envFile if fs.existsSync envFile = path.resolve __dirname, '../.env'
express = require "express"
bodyParser = require 'body-parser'
{ helpers, notFound, locals, setUser, errorHandler } = require './lib/middleware'

app = module.exports = express()

# Middleware
app.use helpers
app.use locals
app.use setUser
app.use bodyParser.json()
app.use bodyParser.urlencoded()

# Apps
app.use require './apps/root'
app.use require './apps/users'
app.use require './apps/posts'

# Moar middleware
app.use errorHandler
app.use express.static __dirname + '/public'
app.use notFound