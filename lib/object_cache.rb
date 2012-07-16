require "object_reader"

class ObjectCache
  @@cache ||= {}
  @@ttl ||= 60
  @@file_or_hash ||= nil
  @@reader ||= nil
  @@expires_at ||= nil


  def self.source(file_or_hash)
    @@file_or_hash = file_or_hash
  end

  def self.expire_after(ttl)
    @@ttl = ttl
  end

  def self.refresh_the_cache
    @@reader ||= Reader.new(@@file_or_hash)
    @@cache ||= {}

    groups = @@reader.grouped_objects
    groups.each do |klass, ids|
      #we need both ids and items to be in the same order for this to work
      ids.sort!{|a,b| b.first <=> a.first}
      items = constantize(klass).find(ids.collect(&:last))
      items.sort!{|a,b| b.id <=> a.id}

      items.each do |item|
        i ||= 0
        @@cache[ids[i][0].to_s] = item
        i+=1
      end
      
    end
    @@expires_at = Time.now + (@@ttl || 5.minutes)
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

  def self.hash
    @@hash
  end

  def self.method_missing(method_name)
    if @@cache.empty? || @@expires_at < Time.now
      refresh_the_cache
    end

    @@cache[method_name.to_s]
  end

end