request = require 'superagent'
post = {
  id: '54276766fd4f50996aeca2b8'
  title: 'Top Ten Booths',
  teaser: 'Just before the lines start forming...',
  thumbnail: 'http://kitten.com',
  tags: ['Fair Coverage', 'Magazine']
  content_title: 'Top Ten Booths at miart 2014',
  preamble: 'Just before the lines start forming...',
  author_id: '4d8cd73191a5c50ce200002a',
  published: true,
  published_at: '1994-11-05T08:15:30-05:00',
  updated_at: '1994-11-05T08:15:30-05:00',
  sections: [
    {
      type: 'image',
      url: 'http://gemini.herokuapp.com/123/miaart-banner.jpg'
    },
    {
      type: 'text',
      body: '## 10. Lisson Gallery\nMia Bergeron merges the _personal_ and _universal_...',
    },
    {
      type: 'artworks',
      ids: ['5321b73dc9dc2458c4000196', '5321b71c275b24bcaa0001a5']
    },
    {
      type: 'text',
      body: 'Check out this video art:',
    },
    {
      type: 'video',
      url: 'http://youtu.be/yYjLrJRuMnY'
    }
  ]
}
token = 'sPH1d_f1p92S_DD8Chuvw_D-qr8IUc5tfq9BSP_5DpfdoskDhxnS3--YsdttLr_VKAI4fOb3PhOcwPtDwUGZLOjIASpPE4gWjuMPY6wUPDUytSX7FPRov-RzzAfLI64lcoCACyc_ykzM5nWdvKvDNCTMZ_kcB2lJ0EW6lfh6s7Z1ilsmy1dYTurr5HAygso4ro8D7JSEw2y6aocDFf3mND6ofLgot9WIz7qDW8RdjAtm5ZHiwadJrZAbbbAbwP-jESu5lS-FMJojj0gPBqxymPQmO7Vc-IW6OI_CTmUVWPOUHkr1oyyxvUTKRk90o8RPU5fI1ZtC9d97oKiS_iXEdQ=='
request
  .post("http://localhost:3005/api/v1/posts")
  .set('X-Access-Token': token)
  .end (err, res) ->
    console.log res.body, 'moo'