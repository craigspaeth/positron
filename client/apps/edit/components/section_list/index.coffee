#
# Top-level component that manages the section tool & the various individual
# section components that get rendered.
#

_ = require 'underscore'
SectionContainer = -> require('../section_container/index.coffee') arguments...
SectionTool = -> require('../section_tool/index.coffee') arguments...
React = require 'react'
{ div } = React.DOM

module.exports = React.createClass

  getInitialState: ->
    editingIndex: null, sections: @props.sections

  onSetEditing: (i) -> (editing) => =>
    @setState editingIndex: if editing then i else null

  onNewSection: (i) -> (section) =>
    @state.sections.splice i, 0, section
    @setState sections: @state.sections, editingIndex: i

  onRemoveSection: (i) -> =>
    @state.sections.splice i, 1
    @setState sections: @state.sections, editingIndex: null

  render: ->
    div {},
      div {
        className: 'edit-section-list' + (' esl-children' if @state.sections.length)
        ref: 'sections'
      },
        SectionTool { onNewSection: @onNewSection(@state.sections.length) }
        for section, i in @state.sections
          [
            SectionContainer {
              section: section
              editing: @state.editingIndex is i
              onSetEditing: @onSetEditing(i)
              onRemoveSection: @onRemoveSection(i)
            }
            SectionTool { onNewSection: @onNewSection(i + 1) }
          ]
