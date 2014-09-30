CurrentUser = require '../../models/current_user'
{ fabricate2 } = require 'antigravity'

@post =
  id: 2
  cache_key: "posts/2-20140718213304818947000"
  title: "The art in Copenhagen is soo over"
  sections_count: 0
  created_at: "2014-07-18 17:33:04 -0400"
  updated_at: "2014-07-18 17:33:04 -0400"
  _links:
    self:
      href: "http://spooky-production.herokuapp.com/api/posts/2"

    sections_url:
      href: "http://spooky-production.herokuapp.com/api/posts/2/sections"

    posts_url:
      href: "http://spooky-production.herokuapp.com/api/posts"

    root_url:
      href: "http://spooky-production.herokuapp.com/"

@locals =
  user: new CurrentUser name: 'Craig', profile: fabricate2 'profile'
  sd:
    PATH: '/'
  moment: require 'moment'
  sharify:
    script: -> '<script>var sharify = {}</script>'