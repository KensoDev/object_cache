require "object_cache/cache_store"

class ObjectCache
  class MemoryStore < ObjectCache::CacheStore
    @@cache = {}
    @@hash = {}

    def self.fetch(klass, ids)
      results = []
      to_set = []
      [*ids].each do |id|
        if @@cache[klass] && @@cache[klass][id] && (Time.now - @@cache[klass][id].last) < ObjectCache.ttl
          results << get(klass, id)
        else
          to_set << id
        end
      end

      fresh_results = fetch_fresh_results(klass, to_set)
      results += fresh_results if fresh_results
      results.compact!

      # if we're asking for one object, we want it,
      # if asking for array, we expect array of objects back
      if ids.class == Array
        results
      else
        results.first
      end
    end

    def self.fetch_fresh_results(klass, to_set)
      #puts to_set.inspect
      return nil if to_set.size == 0
      results = []
      fresh_results = fetch_from_array(klass, to_set)

      fresh_results.each do |item|
        results << set(klass, item.id, item)
      end

      results
    end

    def self.get(klass, id)
      @@cache[klass][id].first
    end

    def self.set(klass, id, item)
      @@cache[klass] ||= {}
      @@cache[klass][id] = [item, Time.now]
      @@cache[klass][id].first
    end

    def self.hash_empty?
      @@hash.empty?
    end

    def self.hash_get(key)
      @@hash[key]
    end

    def self.hash_set(key, value)
      @@hash[key] = value
    end

  end
end