#
# Main server the mounts the Ezel client app & API app.
#

express = require 'express'

app = module.exports = express()
app.use '/api', require './api'
app.use require './client'

# Start the server and send a message to IPC for the integration test
# helper to hook into.
app.listen process.env.PORT, ->
  console.log "Listening on port " + process.env.PORT
  process.send? "listening"