#
# Loads the .env file and injects into sharify to share config on the client.
#

fs = require 'fs'
path = require 'path'
env = require 'node-env-file'
env envFile if fs.existsSync envFile = path.resolve __dirname, '../../../.env'
sharify = require 'sharify'

sharify.data =
  API_URL: process.env.API_URL
  APP_URL: process.env.APP_URL
  NODE_ENV: process.env.NODE_ENV
  SPOOKY_URL: process.env.SPOOKY_URL
  FORCE_URL: process.env.FORCE_URL
  ARTSY_URL: process.env.ARTSY_URL