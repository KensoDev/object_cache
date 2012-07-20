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

### Class cache

Class cache uses the ObjectCache::ClassCacher.cache("Foo", [1,2,3]) syntax to store Foo objects with ids 1,2,3 in cache (they can then be accessed in any permutation via ObjectCache::ClassCacher.cache("Foo", 1)

We recommend doing something like this to make the implementation easier:

    class Foo < ActiveRecord::Base

      def self.cache(ids=[])
        ObjectCache::ClassCacher.cache("Foo", ids)
      end

    end

and from this point simply use object_cache by:

    Foo.cache(1)
    Foo.cache(1,2,3)
    or
    Foo.cache([1,2,3])

### Cache Stores

by default, ObjectCache stores the cached objects in memory, using the ObjectCache::MemoryStore class. The current supported stores are memory store and rails store which uses Rails' abstraction of cache store to store the objects.

in the object_cache initializer define the cache store by doing this:

    require "object_cache/rails_store"
    ObjectCache.cache_store = ObjectCache::RailsStore

The rails cache store assumes that Rails.cache is defined, and will use whatever cache store you're using in your rails application.

This can be easily customizable, and you can write your own cache store if you like (feel free to contribute)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
