gn = require './index'
_ = require 'lodash'
cheerio = require 'cheerio'
q = require 'q'

# Create a new email
get_link = ( subject, contains_text, token ) ->

  link_text = q.defer()

  gn.get_list(token).then (data) ->
    return _.find(data.list, {mail_subject: subject})['mail_id']
  .then (email_id) ->
    gn.fetch_email(token, email_id).then (data) ->
      $ = cheerio.load(data.mail_body)
      link_text.resolve $("a:contains(#{contains_text})").text()

  return link_text.promise

get_link('NextGxDx Email Activation', 'activation', 'qh380p749g3un90e2egnur7v01').then (link_text) ->
  console.log link_text

