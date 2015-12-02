#
# Fullscreen section that allows uploading large overflowing images and an intro text.
#

# Using `try` here b/c Scribe is an AMD module that doesn't play nice when
# requiring it for testing in node.
try
  Scribe = require 'scribe-editor'
  scribePluginToolbar = require 'scribe-plugin-toolbar'
  scribePluginSanitizer = require '../../lib/sanitizer.coffee'
_ = require 'underscore'
gemup = require 'gemup'
React = require 'react'
toggleScribePlaceholder = require '../../lib/toggle_scribe_placeholder.coffee'
sd = require('sharify').data
{ div, section, h1, h2, span, img, header, input, nav, a, button, p } = React.DOM
{ crop, resize, fill } = require('embedly-view-helpers')(sd.EMBEDLY_KEY)

module.exports = React.createClass

  getInitialState: ->
    title: @props.section.get('title')
    intro: @props.section.get('intro')
    background_url: @props.section.get('background_url')
    progress: ''

  componentDidMount: ->
    @attachScribe()

  componentDidUpdate: ->
    @attachScribe()

  onClickOff: ->
    if @state.title
      @props.section.set
        title: @state.title
        intro: @state.intro
        background_url: @state.background_url
    else
      @props.section.destroy()

  upload: (e) ->
    @props.setEditing(off)()
    gemup e.target.files[0],
      key: sd.GEMINI_KEY
      progress: (percent) =>
        @setState progress: percent
      add: (src) =>
        @setState src: src, progress: 0.1
      done: (src) =>
        image = new Image()
        image.src = src
        image.onload = =>
          @setState src: src, progress: null
          @onClickOff()

  attachScribe: ->
    return if @scribe? or not @props.editing
    @scribe = new Scribe @refs.editable.getDOMNode()
    @scribe.use scribePluginSanitizer {
      tags:
        p: true
        b: true
        i: true
        a: { href: true, target: '_blank' }
    }
    @scribe.use scribePluginToolbar @refs.toolbar.getDOMNode()
    toggleScribePlaceholder @refs.editable.getDOMNode()

  onEditableKeyup: ->
    toggleScribePlaceholder @refs.editable.getDOMNode()
    @setState caption: $(@refs.editable.getDOMNode()).html()

  render: ->
    section {
      className: 'edit-section-fullscreen'
      onClick: @props.setEditing(true)
    },
      header { className: 'edit-section-controls' },
        section { className: 'esf-background-upload-container' },
          span { className: 'esf-change-background'}, if @props.section.get('url') then '+ Add Background' else '+ Change Background'
        div { className: 'esf-caption-container' },
          nav { ref: 'toolbar', className: 'edit-scribe-nav esf-nav' },
            button {
              'data-command-name': 'bold'
              dangerouslySetInnerHTML: __html: '&nbsp;'
              disabled: if @state.caption then false else true
            }
          div {
            className: 'esf-caption bordered-input'
            ref: 'editable'
            onKeyUp: @onEditableKeyup
            dangerouslySetInnerHTML: __html: @props.section.get('caption')
          }
      (
        if @state.progress
          div { className: 'upload-progress-container' },
            div {
              className: 'upload-progress'
              style: width: (@state.progress * 100) + '%'
            }
      )
      (
        if @state.background_url
          img {
            className: 'esf-image'
            src: if @state.progress then @state.src else resize(@state.src, width: 900)
            style: opacity: if @state.progress then @state.progress else '1'
            key: 0
          }
        else
          div { className: 'esf-placeholder' }
      )
