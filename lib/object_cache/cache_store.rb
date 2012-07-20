class ObjectCache
  class CacheStore
    class << self
      
      def fetch(klass, ids)
        raise NotImplementedError
      end

      def get(klass, id)
        raise NotImplementedError
      end

      def set(klass, id, value)
        raise NotImplementedError
      end

      def hash_get(key)
        raise NotImplementedError
      end

      def hash_set(key, value)
        raise NotImplementedError
      end

      def fetch_from_array(klass, ids)
        ObjectCache.constantize(klass).find(ids)
      end

      def fetch_fresh_results(klass, to_set)
        #puts to_set.inspect
        return nil if to_set.size == 0
        results = []
        fresh_results = fetch_from_array(klass, to_set)

        fresh_results.each do |item|
          results << set(klass, item.id, item)
        end

        results
      end

      def array_or_value(results, ids)
        if ids.class == Array
          results
        else
          results.first
        end
      end

    end
  end
end