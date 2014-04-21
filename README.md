# Stump

[![Code Climate](https://codeclimate.com/github/nicohvi/stump.png)](https://codeclimate.com/github/nicohvi/stump)
[![Build Status](https://travis-ci.org/nicohvi/stump.svg?branch=v2.0)](https://travis-ci.org/nicohvi/stump)
[![Dependency Status](https://gemnasium.com/nicohvi/stump.png)](https://gemnasium.com/nicohvi/stump)
[![Gem Version](https://badge.fury.io/rb/stump.png)](http://badge.fury.io/rb/stump)

Stump is a minimal wrapper around the standard ruby `logger` that provides
logging to a log file and STDOUT, **at the same time** - something which is for some reason
rather hard to do for rack-based applications not using Rails. It also provides
an `access_log` which you can write to STDOUT and (if you wish) a log file.

The gem accomplishes this by wrapping the standard logger within an IO-object,
which writes to a file and STDOUT both.

Why call it Stump? It's like a small (tree) log, get it? Get it?

## Usage

````
# Gemfile
gem 'stump'

# configuration file for your rack-based application
require 'stump'

logger = Stump::Logger.new
````

Now, whenever you call `logger.debug` (or any other log level for that matter)
your log messages are logged through stump to STDOUT. Of course, this is
possible through the standard logger as well, so to use stump properly you'd
want to pass a path to a log-file so log messages get captured to the file as
well, like so:

````
logger = Stump::Logger.new 'tmp/log.tmp'

````

To enable the access log (which will log to the previously specified logging
targets), simply add the following line (which sets up the rack middleware):

````
use Stump::AccessLog, logger

````

## Example
The following example demonstrates usage of `stump`in a vanilla, minimal
`sinatra` application. You can *literally* copy this code and run the example
in less than a minute.

````
# Gemfile
source 'https://rubygems.org'

gem 'sinatra'
gem 'stump'

# hi.rb
require 'sinatra'
require 'stump'

logger = Stump::Logger.new "tmp/log.log"
logger.level = Logger::DEBUG
use Stump::AccessLog, logger

get '/hi' do
  logger.debug 'hello'
  'What came first - the cat or the internet?'
end

````

Run `bundle` and `ruby hi.rb`, point your brower to `localhost:4567/hi`
and witness the magic.

For those of you disinclined to witness said magic, this example application will
log all outputs to **both** STDOUT and an external file, *tmp/log.tmp*. It looks
something like this:

````
# tmp/tmp.log
, [2014-04-21T10:27:54.045051 #54914] DEBUG -- : hello
localhost - - [21/Apr/2014:10:27:54 CEST] "GET /hi HTTP/1.1" 200 3
localhost - - [21/Apr/2014:10:27:54 CEST] "GET /favicon.ico HTTP/1.1" 404 448
````


## Issues

"Hey, it's not working!"

This can totally happen, so just open up an issue and I'll get right on it!


## License

Copyright (c) @nicovhi, released under the MIT License.
