# ObjectCache

Simple object caching for ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'object_cache'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install object_cache

## Usage

in an initializer define ObjectCache.source "path_to_yml_file"
and optional ObjectCache.ttl 5.minutes (or anything else)

From that moment on you can use ObjectCache.key to access the object you defined as "key".

The yml file looks like this:

    key:
      name: ClassName
      id: 4
    another_key:
      name: ClassName
      id: 5

it assumes ClassName has a method find which can be used by ClassName.find([4,5]) and returns the correct objects. (usually ActiveRecord, but can be used for mongoid objects, etc.)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
