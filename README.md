# node-guerrilla
## API wrapper for http://www.guerrillamail.com



```CoffeeScript
gn = require 'node-guerrilla'

# Creates a new random email
gn.get_email()
.then (account) ->
  
  # Checks email on an interval and searches for a link that matches 'string_to_find'
  gn.get_link_poll('Test Email', 'string_to_find', account.sid_token)
  .then (link) ->
    console.log link
```
