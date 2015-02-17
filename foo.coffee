Joi = require 'joi'

schema = Joi.object().keys({
  foo: Joi.date()
})

schema.validate { foo: 'Mon Jan 1st 2001' }, (err, value) ->
  console.log 'mooo', err, value