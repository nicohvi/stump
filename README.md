# Stump

Hey - logging in `sinatra` (or other rack-based applications other than Rails) is a lot more cumbersome than
it needs to be, right? Totally, it's about time someone came up with a nifty name for a gem and did something
about it. Someone totally did.

`stump` uses the basic Ruby logger to do some neat stuff, so you can go to that fancy pantsuit party rather
than sitting at home writing configurations. Why call it `stump`? It's like a small (tree) log, get it? Get it?

## Usage

(For the **tldr**, scroll down!)

To enable logging for your rack-based application simply add the following

    require 'stump'
    use Stump::StumpLogger

And you will have log messages written to STDOUT in the following format

    SeverityID, [Date Time mSec #pid] SeverityLabel -- ProgName: message
    # I, [Wed Mar 10 02:34:24 JST 1999 895701 #19074]  INFO -- Main: It's the 69th day of the year!

That's no fun though, wouldn't it be cooler to, say, add an access log as well? It totally would be.

    use Stump::StumpLogger, { access_log: true }

Requests to your application now get logged to STDOUT following the [Apache Common Log Format](http://httpd.apache.org/docs/1.3/logs.html#common),
in addition to the usual logging - pimpin'!

    I, [Wed Mar 10 02:34:24 JST 1999 895701 #19074]  INFO -- Main: It's the 69th day of the year!
    192.168.0.10 - root - [10/Mar/1999:02:34:24 +0100] "GET /passwords HTTP/1.1" 404 0.0057

You can also set the logging *threshold* by applying one more argument to `stump`

    use Stump::StumpLogger, { access_log: true, level_threshold: 'debug' }

Accepted formats for the `threshold` are: `'debug', 'info', 'warn'`(defaults to `'debug'`).

I've even added my own custom logging format (the standard format in the Ruby logger is so boring) - you can use it like this:

    use Stump::StumpLogger, { custom_format: true }

This will give you log messages that look like this

    severity @ [datetime] : message
    # DEBUG @ [1999-03-10 13:37:00] : Is this a national holiday yet?

Now, to go *even further* - wouldn't it be amazing if we could log to a file *as well as STDOUT*? You know it.

    stump = Stump::Config.init({ path: "log(#{ENV['RACK_ENV']}.log" })

Would set up a new `stump` logger to point to a file called (for the `development` environment) `log/development.log`.
You can also control the *shift age* (frequency of rotation between log files) by supplying an extra argument like so:

    stump = Stump::Config.init({ path: "log(#{ENV['RACK_ENV']}.log", shift_age: 'daily' })

In order to get the `stump` middleware to use the newly created `stump`, add the following line

    use Stump::StumpLogger, { logger: stump }

To set up your new `stump` with all the goodies in this gem write the following

    use Stump::StumpLogger, { logger: stump, access_log: true, level_threshold: info, custom_format: true }

Which would give you the following log output (to both a file of your choosing and STDOUT)

    192.168.0.11 - - [21/Dec/2012:00:00:01} "GET /doom HTTP/1.1" 500 0.1337
    WARN @ [2012-12-21 00:00:01] : The world is ending, did you remember to bring fancy hats?

Now you can watch in joy while all the requests to your application get logged to **both** STDOUT and the file
you specified. Pat yourself on the back and have a well-deserved burrito while you envision all the interesting
conversations you'll have at that pantsuit party.

## TLDR

Yeah, it's boring to read.

    require 'stump'

    stump = Stump::Config.init({ path: "log(#{ENV['RACK_ENV']}.log", shift_age: 'daily' })
    use Stump::StumpLogger, { logger: stump, access_log: true, level_threshold: info, custom_format: true }

## Issues

"Hey, it's not working!"

This can totally happen, so just open up an issue and I'll get right on it!


## License

Copyright (c) @nicovhi, released under the MIT License.