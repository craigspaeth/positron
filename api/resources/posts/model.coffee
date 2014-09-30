#
# Transaction script for the posts collection.
# http://martinfowler.com/eaaCatalog/transactionScript.html
#
# Example Schema:
# {
#   id: '54276766fd4f50996aeca2b8'
#   title: 'Top Ten Booths',
#   teaser: 'Just before the lines start forming...',
#   thumbnail: 'http://kitten.com',
#   tags: ['Fair Coverage', 'Magazine']
#   content_title: 'Top Ten Booths at miart 2014',
#   preamble: 'Just before the lines start forming...',
#   author_id: '4d8cd73191a5c50ce200002a',
#   published: true,
#   published_at: '1994-11-05T08:15:30-05:00',
#   updated_at: '1994-11-05T08:15:30-05:00',
#   sections: [
#     {
#       type: 'image',
#       url: 'http://gemini.herokuapp.com/123/miaart-banner.jpg'
#     },
#     {
#       type: 'text',
#       body: '## 10. Lisson Gallery\nMia Bergeron merges the _personal_ and _universal_...',
#     },
#     {
#       type: 'artworks',
#       ids: ['5321b73dc9dc2458c4000196', '5321b71c275b24bcaa0001a5']
#     },
#     {
#       type: 'text',
#       body: 'Check out this video art:',
#     },
#     {
#       type: 'video',
#       url: 'http://youtu.be/yYjLrJRuMnY'
#     }
#   ]
# }

mongoose = require 'mongoose'
Schema = mongoose.Schema
{ ObjectId, Mixed } = Schema.Types

postSchema = new Schema
  title: String
  teaser: String
  thumbnail: String
  tags: [String]
  content_title: String
  preamble: String
  author_id: String
  published: Boolean
  published_at: Date
  updated_at: Date
  sections: [Mixed]

module.exports = mongoose.model 'Post', postSchema