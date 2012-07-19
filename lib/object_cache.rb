require "object_reader"
require "object_cache/class_cacher"
require "object_cache/memory_store"

class ObjectCache
  @@cache ||= {}
  @@ttl ||= 300
  @@file_or_hash ||= nil
  @@reader ||= nil
  @@expires_at ||= nil
  @@cache_store ||= ObjectCache::MemoryStore


  def self.source(file_or_hash)
    @@file_or_hash = file_or_hash
  end

  def self.expire_after(ttl)
    @@ttl = ttl
  end

  def self.ttl
    @@ttl
  end

  def self.cache_store
    @@cache_store
  end

  def self.refresh_the_cache
    @@reader ||= Reader.new(@@file_or_hash)

    groups = @@reader.grouped_objects
    groups.each do |klass, ids|
      #we need both ids and items to be in the same order for this to work
      ids.sort!{|a,b| a.last <=> b.last}
      items = constantize(klass).find(ids.collect(&:last))
      items.sort!{|a,b| a.id <=> b.id}

      @i = 0
      items.each do |item|
        cache_store.hash_set(ids[@i].first.to_s, item)
        #@@cache[ids[@i].first.to_s] = item
        @i+=1
      end
      
    end
    @@expires_at = Time.now + (@@ttl || 300)
  end

  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

  def self.method_missing(method_name)
    if cache_store.hash_empty? || @@expires_at < Time.now
      refresh_the_cache
    end

    cache_store.hash_get(method_name.to_s)
  end

end