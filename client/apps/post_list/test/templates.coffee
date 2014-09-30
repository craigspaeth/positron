_ = require 'underscore'
jade = require 'jade'
moment = require 'moment'
fs = require 'fs'
Backbone = require 'backbone'
Posts = require '../../../collections/posts'
fixtures = require '../../../test/helpers/fixtures'
{ resolve } = require 'path'

render = (locals) ->
  filename = resolve __dirname, "../index.jade"
  jade.compile(
    fs.readFileSync(filename),
    { filename: filename }
  ) _.extend locals, fixtures.locals

describe 'post list template', ->

  it 'renders an post title', ->
    posts = new Posts([fixtures.post])
    posts.first().set title: 'Hello Blue World'
    render(posts: posts.models).should.containEql 'Hello Blue World'