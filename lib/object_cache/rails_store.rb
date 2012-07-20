require "object_cache/cache_store"

class ObjectCache
  class RailsStore < ObjectCache::CacheStore
    class << self

      def fetch(klass, ids)
        results = []
        ids_to_refresh = []

        [*ids].each do |id|
          if Rails.cache.exist?(cache_key(klass, id))
            results << get(klass, id)
          else
            ids_to_refresh << id
          end
        end

        fresh_results = fetch_fresh_results(klass, ids_to_refresh)
        results += fresh_results if fresh_results

        array_or_value(results, ids)
      end

      def get(klass, id)
        Rails.cache.read(cache_key(klass, id))
      end

      def set(klass, id, value)
        Rails.cache.write(cache_key(klass, id), value, expires_at: ObjectCache.ttl)
      end

      def cache_key(klass, id)
        "object_cache:#{klass}:#{id}"
      end

      def hash_get(key)
        Rails.cache.read(hash_key(key))
      end

      def hash_set(key, value)
        Rails.cache.write(hash_key(key), value, expires_at: ObjectCache.ttl)
      end

      def hash_key(key)
        "object_cache:#{key}"
      end

    end
  end
end