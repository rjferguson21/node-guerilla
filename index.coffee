qs = require 'querystring'
q = require 'q'
request = require 'request'
_ = require 'lodash'
cheerio = require 'cheerio'

make_request = (params) ->

  deferred = q.defer()

  base_url = 'https://www.guerrillamail.com/ajax.php'

  request_url = base_url + '?' + qs.stringify( params )

  request(request_url, (error, response, body) ->
    if response.statusCode isnt 200
      deferred.reject response.statusCode
    else
      deferred.resolve JSON.parse(body)
  )

  return deferred.promise

make_post_request = (params, data) ->

  deferred = q.defer()

  base_url = 'https://www.guerrillamail.com/ajax.php'

  request_url = base_url + '?' + qs.stringify( params )

  request.post( request_url, {form: data}, (error, response, body) ->
    if response.statusCode is 200
      deferred.resolve JSON.parse(body)
    else
      deferred.reject error
  )

  return deferred.promise

# gets a new email address
get_email = ->
  return make_request({f: 'get_email_address', lang: 'en'})

# sets the current email address
set_email = (token, email, domain) ->
  return make_post_request({f:'set_email_user'}, {email_user: email, sid_token: token, domain: domain})

# gets a list of mail
check_email = (token) ->
  return make_request({f:'check_email', sid_token: token, seq: 0})

  # gets a list of mail
get_list = (token) ->
  return make_request({f:'get_email_list', sid_token: token, offset: 0})

# fetch an individual email
fetch_email = (token, email_id) ->
  return make_request({f:'fetch_email', sid_token: token, email_id: email_id})

# helper functions

get_link = (subject, contains_text, token) ->

  link_text = q.defer()

  gn.get_list(token).then (data) ->
    email_object = _.find(data.list, {mail_subject: subject})
    if email_object?
      return email_object['mail_id']
    else
      link_text.reject 'no_email'
  .then (email_id) ->
    gn.fetch_email(token, email_id).then (data) ->
      $ = cheerio.load(data.mail_body)
      link_text.fulfill $("a:contains(#{contains_text})").text()
  .then null, (error) ->
    link_text.reject error

  return link_text.promise

get_link_poll = (subject, contains_text, token) ->

  link = q.defer()

  check_email = setInterval ->
    get_link(subject, contains_text, token).then (email) ->
      link.resolve email
      clearInterval(check_email)
  , 3000

  return link.promise

gn = {
  get_email
  set_email
  check_email
  fetch_email
  get_list
  get_link
  get_link_poll
}

module.exports = gn




