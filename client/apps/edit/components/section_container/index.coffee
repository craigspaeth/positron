#
# Generic section container component that handles things like hover controls
# and editing states. Also decides which section to render based on the
# section type.
#

SectionText = require '../section_text/index.coffee'
SectionArtworks = require '../section_artworks/index.coffee'
SectionImage = require '../section_image/index.coffee'
SectionVideo = require '../section_video/index.coffee'
React = require 'react'
{ div, nav, button } = React.DOM
icons = -> require('./icons.jade') arguments...

module.exports = React.createClass

  getInitialState: ->
    layout: @props.section.layout

  onClickOff: ->
    @props.onSetEditing(off)()
    @refs.section?.onClickOff?()

  onChangeLayout: (layout) -> =>
    @setState layout: layout

  render: ->
    div {
      className: 'edit-section-container'
      'data-state-editing': @props.editing
      'data-type': @props.section.type
      'data-layout': @state.layout
    },
      div {
        className: 'edit-section-hover-controls'
        onClick: @props.onSetEditing(on)
      },
        button {
          className: 'edit-section-remove button-reset'
          onClick: @props.onRemoveSection
          dangerouslySetInnerHTML: __html: $(icons()).filter('.remove').html()
        }
      (switch @props.section.type
        when 'text' then SectionText
        when 'artworks' then SectionArtworks
        else ->
        # when 'image' then SectionImage
        # when 'video' then SectionVideo
      )(
        section: @props.section
        editing: @props.editing
        ref: 'section'
        onClick: @props.onSetEditing(on)
        onSetEditing: @props.onSetEditing
        onChangeLayout: @onChangeLayout
        onRemoveSection: @props.onRemoveSection
        layout: @state.layout
      )
      div {
        className: 'edit-section-container-bg'
        onClick: @onClickOff
      }
