#
# Auth setup code using passport and friends.
#

sd = require('sharify').data
Backbone = require 'backbone'
passport = require 'passport'
OAuth2Strategy = require 'passport-oauth2'
CurrentUser = require '../../models/current_user'

passport.use 'artsy', new OAuth2Strategy
  authorizationURL: process.env.ARTSY_URL + '/oauth2/authorize'
  tokenURL: process.env.ARTSY_URL + '/oauth2/access_token'
  clientID: process.env.ARTSY_ID
  clientSecret: process.env.ARTSY_SECRET
  callbackURL: process.env.APP_URL + '/auth/artsy/callback'
, (accessToken, refreshToken, profile, done) ->
  # TODO: Pull from API db.

passport.serializeUser (user, done) ->
  done null, user.pick 'id', 'name', 'profile', 'accessToken'

passport.deserializeUser (userData, done) ->
  done null, new CurrentUser userData

module.exports = (app) ->
  app.use passport.initialize()
  app.use passport.session()
  app.get '/login', passport.authenticate('artsy')
  app.get '/auth/artsy/callback', passport.authenticate 'artsy',
    successRedirect: '/'
    failureRedirect: '/login'
  app.get '/logout', (req, res) ->
    res.redirect sd.ARTSY_URL
  app.use (req, res, next) ->
    if req.user? then next() else res.redirect '/login'