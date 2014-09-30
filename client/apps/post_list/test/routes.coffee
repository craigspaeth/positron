routes = require '../routes'
_ = require 'underscore'
Backbone = require 'backbone'
sinon = require 'sinon'
fixtures = require '../../../test/helpers/fixtures'

describe 'routes', ->

  beforeEach ->
    @req = { query: {} }
    @res = { render: sinon.stub(), locals: sd: {} }

  describe '#posts', ->

    it 'fetches a page of posts', ->
      routes.posts @req, @res
      _.last(spooky.new.args[0])(null, new Backbone.Collection [fixtures.post])
      _.last(@res.render.args[0][1].posts).get('title')
        .should.containEql 'art in'

    it 'pages', ->
      @req.query.page = 2
      routes.posts @req, @res
      spooky.new.args[0][1].should.equal 'posts.next.next.posts'