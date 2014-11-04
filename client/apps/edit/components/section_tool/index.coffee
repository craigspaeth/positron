#
# The section tool that adds new sections between sections or at the bottom
# of the list.
#

React = require 'react'
icons = -> require('./icons.jade') arguments...
{ div, ul, li } = React.DOM

module.exports = React.createClass

  getInitialState: ->
    { open: false }

  toggle: ->
    @setState open: not @state.open

  onNewSection: (type) -> =>
    switch type
      when 'text'
        @props.onNewSection {
          type: 'text'
          body: ''
        }
      when 'artworks'
        @props.onNewSection {
          type: 'artworks'
          ids: []
          layout: 'column_width'
        }
      when 'image'
        @props.onNewSection {
          type: 'image'
          url: ''
        }
      when 'video'
        @props.onNewSection {
          type: 'video'
          url: ''
        }
    @setState open: false

  render: ->
    div { className: 'edit-section-tool', 'data-state-open': @state.open },
      div {
        className: 'edit-section-tool-icon'
        onClick: @toggle
        dangerouslySetInnerHTML: __html:
          if @state.open
            $(icons()).filter('.section-tool-close').html()
          else
            $(icons()).filter('.section-tool').html()
      }
      ul { className: 'edit-section-tool-menu' },
        li {
          className: 'edit-section-tool-text'
          onClick: @onNewSection('text')
        }, 'Text',
          div {
            className: 'edit-menu-icon-text'
            dangerouslySetInnerHTML: __html: $(icons()).filter('.text').html()
          }
        li {
          className: 'edit-section-tool-artworks'
          onClick: @onNewSection('artworks')
        }, 'Artworks',
          div {
            className: 'edit-menu-icon-artworks'
            dangerouslySetInnerHTML: __html: $(icons()).filter('.artworks').html()
          }
        li {
          className: 'edit-section-tool-image'
          onClick: @onNewSection('image')
        }, 'Image',
          div {
            className: 'edit-menu-icon-image'
            dangerouslySetInnerHTML: __html: $(icons()).filter('.image').html()
          }
        li {
          className: 'edit-section-tool-video'
          onClick: @onNewSection('video')
        }, 'Video',
          div {
            className: 'edit-menu-icon-video'
            dangerouslySetInnerHTML: __html: $(icons()).filter('.video').html()
          }
