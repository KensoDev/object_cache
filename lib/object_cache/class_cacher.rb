class ObjectCache
  class ClassCacher
    @@cache = {}

    def self.cache(klass, id)
      ObjectCache.cache_store.fetch(klass, id)
    end

    def self.get_cache
      @@cache
    end

  end
end