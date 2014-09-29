#
# Transaction scripts for the users collection.
# http://martinfowler.com/eaaCatalog/transactionScript.html
#

_ = require 'underscore'
async = require 'async'
db = require '../../lib/db'
request = require 'superagent'
{ ARTSY_URL } = process.env

# Finds or creates a user from an Artsy access token.
#
# @param accessToken {String}
# @param callback {Function}

@fromAccessToken = (accessToken, callback) ->

  # See if the user's already saved in the db
  db.users.findOne { access_token: accessToken }, (err, user) ->
    return callback err if err
    return callback null, user if user

    # If not, fetch the current user from Artsy's API
    request
      .get("#{ARTSY_URL}/api/current_user")
      .set('X-Access-Token': accessToken)
      .end (err, res) ->
        return callback err if err
        return callback res.body unless res.body.id?
        user = res.body

        async.parallel [
          (cb) ->
            request
              .get(user._links.profile.href)
              .set('X-Access-Token': accessToken)
              .end (err, res) -> cb err, res.body
          (cb) ->
            request
              .get(user._links.user_details.href)
              .set('X-Access-Token': accessToken)
              .end (err, res) -> cb err, res.body
        ], (err, results) ->

          # Flatten the various user datas and clean out HAL properties
          user.profile = results[0]
          user.details = results[1]
          delete user._id
          delete user.profile._links
          delete user.details._links
          delete user._links

          # Save the merged user data in the database
          db.users.update { id: user.id }, user, { upsert: true }, (err, res) ->
            return callback err if err
            callback null, user

@present = (user) ->
  _.omit user, '_id', 'access_token'