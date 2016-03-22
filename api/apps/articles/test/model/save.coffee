_ = require 'underscore'
rewire = require 'rewire'
{ fabricate, empty } = require '../../../../test/helpers/db'
Save = rewire '../../model/save'
Article = require '../../model/index'
express = require 'express'
gravity = require('antigravity').server
app = require('express')()
sinon = require 'sinon'

describe 'Save', ->

  before (done) ->
    app.use '/__gravity', gravity
    @server = app.listen 5000, ->
      done()

  after ->
    @server.close()

  beforeEach (done) ->
    @sailthru = Save.__get__ 'sailthru'
    @sailthru.apiPost = sinon.stub().yields()
    Save.__set__ 'sailthru', @sailthru
    Save.__set__ 'artsyXapp', { token: 'foo' }
    empty ->
      fabricate 'articles', _.times(10, -> {}), ->
        done()

  describe '#sendArticleToSailthru', ->

    it 'concats the article tag for a normal article', (done) ->
      Save.sendArticleToSailthru {
        author_id: '5086df098523e60002000018'
        published: true
      }, (err, article) =>
        @sailthru.apiPost.calledOnce.should.be.true()
        @sailthru.apiPost.args[0][1].tags.should.containEql 'article'
        @sailthru.apiPost.args[0][1].tags.should.not.containEql 'artsy-editorial'
        done()

    it 'concats the artsy-editorial and magazine tags for specialized articles', (done) ->
      Save.sendArticleToSailthru {
        author_id: '5086df098523e60002000018'
        published: true
        featured: true
      }, (err, article) =>
        @sailthru.apiPost.calledOnce.should.be.true()
        @sailthru.apiPost.args[0][1].tags.should.containEql 'article'
        @sailthru.apiPost.args[0][1].tags.should.containEql 'magazine'
        done()

    it 'uses email_metadata vars if provided', (done) ->
      Save.sendArticleToSailthru {
        author_id: '5086df098523e60002000018'
        published: true
        email_metadata:
          credit_url: 'artsy.net'
          credit_line: 'Artsy Credit'
          headline: 'Article Email Title'
          author: 'Kana Abe'
          image_url: 'imageurl.com/image.jpg'
      }, (err, article) =>
        @sailthru.apiPost.args[0][1].title.should.containEql 'Article Email Title'
        @sailthru.apiPost.args[0][1].vars.credit_line.should.containEql 'Artsy Credit'
        @sailthru.apiPost.args[0][1].vars.credit_url.should.containEql 'artsy.net'
        @sailthru.apiPost.args[0][1].author.should.containEql 'Kana Abe'
        @sailthru.apiPost.args[0][1].images.full.url.should.containEql 'https://i.embed.ly/1/display/crop?width=1200&height=706&quality=95&key=&url=imageurl.com%2Fimage.jpg'
        @sailthru.apiPost.args[0][1].images.thumb.url.should.containEql 'https://i.embed.ly/1/display/crop?width=900&height=530&quality=95&key=&url=imageurl.com%2Fimage.jpg'
        done()

    it 'uses alternate data if email_metadata is not provided', (done) ->
      Save.sendArticleToSailthru {
        author_id: '5086df098523e60002000018'
        published: true
        thumbnail_image: 'imageurl.com/image.jpg'
        thumbnail_title: 'This Is The Thumbnail Title'
      }, (err, article) =>
        @sailthru.apiPost.args[0][1].title.should.containEql 'This Is The Thumbnail Title'
        @sailthru.apiPost.args[0][1].images.full.url.should.containEql 'https://i.embed.ly/1/display/crop?width=1200&height=706&quality=95&key=&url=imageurl.com%2Fimage.jpg'
        @sailthru.apiPost.args[0][1].images.thumb.url.should.containEql 'https://i.embed.ly/1/display/crop?width=900&height=530&quality=95&key=&url=imageurl.com%2Fimage.jpg'
        done()

    it 'sends the article text body', (done) ->
      Save.sendArticleToSailthru {
        author_id: '5086df098523e60002000018'
        published: true
        send_body: true
        sections: [
          {
            type: 'text'
            body: '<html>BODY OF TEXT</html>'
          }
          {
            type: 'image'
            caption: 'This Caption'
            url: 'URL'
          }
        ]
      }, (err, article) =>
        @sailthru.apiPost.args[0][1].vars.html.should.containEql '<html>BODY OF TEXT</html>'
        @sailthru.apiPost.args[0][1].vars.html.should.not.containEql 'This Caption'
        done()

  describe '#sanitizeAndSave', ->

    it 'skips sanitizing links that do not have an href', (done) ->
      Save.sanitizeAndSave( ->
        Article.find '5086df098523e60002000011', (err, article) =>
          article.sections[0].body.should.containEql '<a></a>'
          done()
      )(null, {
        author_id: '5086df098523e60002000018'
        published: false
        _id: '5086df098523e60002000011'
        sections: [
          {
            type: 'text'
            body: '<a>'
          }
        ]
      })

  describe '#generateArtworks', ->

    it 'denormalizes artworks and adds them as an array to the section', (done) ->
      Save.generateArtworks {
        sections: [
          {
            type: 'artworks'
            layout: 'overflow'
            ids: ['564be09ab202a319e90000e2']
          }
        ]
      }, {}, (err, article) =>
        article.sections[0].artworks.length.should.equal 1
        article.sections[0].artworks[0].title.should.equal 'Main artwork!'
        article.sections[0].artworks[0].artist.name.should.equal 'Andy Warhol'
        done()

    it 'does not save artworks that are not available', (done) ->
      Save.generateArtworks {
        sections: [
          {
            type: 'text'
            body: 'fmodfmsdomf'
          }
          {
            type: 'artworks'
            layout: 'overflow'
            ids: ['123', '564be09ab202a319e90000e2']
          }
        ]
      }, {}, (err, article) =>
        article.sections.length.should.equal 2
        article.sections[1].artworks[0].title.should.equal 'Main artwork!'
        article.sections[1].artworks.length.should.equal 1
        done()

    it 'removes an entire section if there are no available artworks', (done) ->
      Save.generateArtworks {
        sections: [
          {
            type: 'text'
            body: 'fmodfmsdomf'
          }
          {
            type: 'artworks'
            layout: 'overflow'
            ids: ['123']
          }
        ]
      }, {}, (err, article) =>
        article.sections.length.should.equal 1
        done()
