# MultiType

MultiType lets you create weird module-like objects that match object
instances of certain types. If this sentense doesn't seem to make sense,
chances are, you don't really need it anyway.

Here're some potential usecases:

### Type-checks

```ruby
class WhateverMediator < Mediators::Base
  Actor = MultiType[User, Admin]

  def initialize(actor:, action:)
    @actor, @action = actor, action
    unless Actor === actor
      raise ArgumentError, "actor must be of Actor type"
    end
  end

  def call
    # actor performing an action maybe?
  end
end
```

### Error Rescuing

```ruby

class MyClient < Clients::Base
  RetryableErrors = MultiType[
    EOFError,
    Excon::Errors::ResponseParseError,
    Excon::Errors::SocketError,
    Excon::Errors::Timeout,
    OpenSSL::SSL::SSLError,
    SocketError,
    SystemCallError
  ]

  CriticalErrors = MultiType[
    Excon::Errors::Conflict,
    Excon::Errors::Forbidden,
    Excon::Errors::NotAcceptable,
    Excon::Errors::NotFound,
    Excon::Errors::Unauthorized
  ]


  def perform(**params)
    log "performing with #{params}"

    connection.post(
      path: "/call/action",
      body: JSON.dump(params)
    )
  rescue RetryableErrors => error
    log "failed: #{error}"
    log "retrying in 10"
    sleep 10
    retry
  rescue CriticalErrors => error
    log "failed critically: #{error}"
    perform_cleanup
  rescue => error # ¯\_(ツ)_/¯
    log "unexpected error happened: #{error}"
    raise
  end
end
```

### Combining

Combining MultiType with other types or MultiTypes is as easy as creating
a new MultiType including all those things:

```ruby
SocketErrors = MultiType[
  EOFError,
  OpenSSL::SSL::SSLError,
  SocketError,
  SystemCallError,
  Timeout::Error
]

ConnectionErrors = MultiType[
  Excon::Errors::ResponseParseError,
  Excon::Errors::SocketError,
  Excon::Errors::Timeout,
  Net::HTTPBadResponse,
  SocketErrors # note that this is a multi type
]

# or like that. Does the same thing:

ConnectionErrors = SocketErrors.add(
  Excon::Errors::ResponseParseError,
  Excon::Errors::SocketError,
  Excon::Errors::Timeout,
  Net::HTTPBadResponse
)

# Now ConnectionErrors include all SocketErrors and a bunch of new types
```

### Installation

Add this line to your application's Gemfile:

```ruby
gem "multi_type"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multi_type


### Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rwz/multi_type.


### License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

