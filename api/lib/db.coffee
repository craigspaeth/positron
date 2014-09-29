#
# Wraps & exports a mongojs instance. Automatically selects collections based
# on the folder names under /resources.
# https://github.com/mafintosh/mongojs
#

mongojs = require 'mongojs'
fs = require 'fs'
path = require 'path'
{ MONGO_URL } = process.env

collections = fs.readdirSync path.resolve(__dirname, '../resources/')
module.exports = mongojs process.env.MONGO_URL, collections