import React from 'react'
import Backbone from 'backbone'
import { mount } from 'enzyme'
import { RemoveButton } from 'client/components/remove_button/index'
import { SectionContainer } from '../../../section_container/index'
import { SectionTool } from '../../../section_tool/index'
import { SectionHero } from '../index'
import { Fixtures } from '@artsy/reaction-force/dist/Components/Publishing'
const { ClassicArticle } = Fixtures

describe('SectionHero', () => {
  let props

  beforeEach(() => {
    props = {
      article: new Backbone.Model(ClassicArticle),
      channel: new Backbone.Model(),
      onChange: jest.fn()
    }
  })

  it('Displays a sectionTool if no section', () => {
    props.article.set('hero_section', null)
    const component = mount(
      <SectionHero {...props} />
    )
    expect(component.find(SectionTool).length).toBe(1)
    expect(component.find(SectionContainer).length).toBe(0)
  })

  it('Displays a sectionContainer has section', () => {
    props.article.set({
      hero_section: {
        url: 'http://youtube.com',
        type: 'video'
      }
    })
    const component = mount(
      <SectionHero {...props} />
    )
    expect(component.find(SectionTool).length).toBe(0)
    expect(component.find(SectionContainer).length).toBe(1)
  })

  it('Can remove a hero if empty', () => {
    props.article.set({
      hero_section: {
        type: 'video'
      }
    })
    const component = mount(
      <SectionHero {...props} />
    )
    component.find(RemoveButton).simulate('click')
    expect(props.onChange.mock.calls[1][0]).toBe('hero_section')
    expect(props.onChange.mock.calls[1][1]).toBe(null)
  })
})
