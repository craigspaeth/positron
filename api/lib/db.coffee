mongojs = require 'mongojs'
fs = require 'fs'
path = require 'path'
{ MONGO_URL } = process.env

collections = fs.readdirSync path.resolve(__dirname, '../apps/')
module.exports = mongojs process.env.MONGO_URL, collections