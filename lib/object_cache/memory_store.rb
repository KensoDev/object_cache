require "object_cache/cache_store"

class ObjectCache
  class MemoryStore < ObjectCache::CacheStore
    @@cache = {}
    @@hash = {}

    def self.fetch(klass, id)
      if @@cache[klass] && @@cache[klass][id] && (Time.now - @@cache[klass][id].last) < ObjectCache.ttl
        get(klass, id)
      else
        set(klass, id)
      end
    end

    def self.get(klass, id)
      @@cache[klass][id].first
    end

    def self.set(klass, id)
      @@cache[klass] ||= {}
      @@cache[klass][id] = [ObjectCache.constantize(klass).find(id), Time.now]
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