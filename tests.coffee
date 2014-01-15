gn = require './index'

gn.get_email()
.then (account) ->
  console.log account
  gn.get_link_poll('Test Email', 'nextgxdx', account.sid_token)
  .then (link) ->
    console.log link




