{ present } = User = require './transaction_script'
{ API_URL } = process.env

@me = (req, res, next) ->
  res.send present req.user

@doc = (req, res) ->
  res.render 'doc'