qs = require 'querystring'
q = require 'q'
request = require 'request'


current_email = {}

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

make_post_request = (params) ->

  deferred = q.defer()

  base_url = 'https://www.guerrillamail.com/ajax.php'

  request_url = base_url + '?' + qs.stringify( params )

  request.post( request_url, {form: params}, (error, response, body) ->
    if response.statusCode is 200
      deferred.resolve body
    else
      deferred.reject error
  )

  return deferred.promise

get_email = ->
  return make_request({f: 'get_email_address', lang: 'en'})

set_email = (token) ->
  return make_post_request({f:'set_email_address', sid_token: token})

check_email = (token) ->
  return make_request({f:'check_email', sid_token: token, seq: 0})

# Create a new email

# get_email().then (current_email) ->
#   return current_email.sid_token
# .then (token) ->
#   set_email(token)
#   return token
# .then (token) ->
#     check_email(token).then (data) ->
#       console.log data

# Check an existing email

# set_email('qspfm7o3fhc0gf676mb4sjlk15')
# .then ->
#   check_email('qspfm7o3fhc0gf676mb4sjlk15')
# .then (data) ->
#   console.log data


exports.get_email = get_email
exports.set_email = set_email
exports.check_email = check_email




