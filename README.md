# node-guerrilla
## API wrapper for http://www.guerrillamail.com



```CoffeeScript
gn = require 'node-guerrilla'

gn.get_email()
.then (account) ->
  gn.get_link_poll('Test Email', 'string_to_find', account.sid_token)
  .then (link) ->
    console.log link
```
