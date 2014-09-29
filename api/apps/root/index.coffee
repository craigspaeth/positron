express = require 'express'
{ API_URL } = process.env

app = module.exports = express()
app.set 'views', __dirname
app.set 'view engine', 'jade'

app.get '/v1', (req, res) ->
  res.redirect API_URL.replace '/v1', ''
app.get '/', (req, res) ->
  res.render 'index'