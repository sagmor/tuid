# Time based Unique IDentifiers

TUIDs are values compatible with UUIDs

They share the same base formati, so can be used instead of them.
The main property of TUIDs is that they are prefixed by the time they
were generated. Which allow them to be sorted and behave better on database
indexes.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tuid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tuid

## Usage

```ruby
# Generate a random TUID
tuid = TUID.new
#=> #<TUID 56342da3-7cc0-280d-f0b8-507634551518(2015-10-30 23:55:31 -0300)>

# Get its generation time
tuid.time
#=> 2015-10-30 23:55:31 -0300

# Turn it into a String
tuid.to_s
#=> "56342da3-7cc0-280d-f0b8-507634551518"

# Generate a TUID from a UUID formated string
tuid2 = TUID.new("56342da3-7cc0-280d-f0b8-507634551518")
#=> #<TUID 56342da3-7cc0-280d-f0b8-507634551518(2015-10-30 23:55:31 -0300)>

# And they can be compared
tuid == tuid2
#=> true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sagmor/tuid. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

