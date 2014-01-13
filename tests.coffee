gn = require 'node-guerilla'
_ = require 'lodash'

# Create a new email

gn.set_email('qh380p749g3un90e2egnur7v01', 'pivtdrlb', 'guerrillamailblock.com')
.then (current_email) ->
  return current_email
.then ->
  gn.check_email('qh380p749g3un90e2egnur7v01').then (data) ->
    return _.find(data.list, {mail_subject: 'NextGxDx Email Activation'})['mail_id']
  .then (email_id) ->
    gn.fetch_email('qh380p749g3un90e2egnur7v01', email_id).then (data) ->
      console.log data













# gn.fetch_email('qh380p749g3un90e2egnur7v01', '47223075').then (data) ->
#   console.log data
