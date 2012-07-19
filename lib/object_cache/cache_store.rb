class ObjectCache
  class CacheStore
    class << self
      def get(klass, id)
        raise NotImplementedError
      end

      def set(klass, id, valie)
        raise NotImplementedError
      end

      def hash_get(key)
        raise NotImplementedError
      end

      def hash_set(key, value)
        raise NotImplementedError
      end
    end
  end
end