#
# Main app file. This code should be kept to a minimum.
# Any setup code that gets large should be abstracted into modules under /lib.
#

require './lib/setup/config'
setup = require "./lib/setup"
express = require "express"

app = module.exports = express()
setup app