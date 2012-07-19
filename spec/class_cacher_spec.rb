require 'spec_helper'

class Foo
  def self.find(ids)
    query
    return ids
  end

  def self.query
    #this method gets called when Foo.find is called, represents a "query" to the db
  end
end

describe ObjectCache::ClassCacher do
  describe "calling of cache" do

    it "should not perform a query after the object is cached" do
      ObjectCache::ClassCacher.cache("Foo", 1)
      Foo.should_not_receive(:query)
      ObjectCache::ClassCacher.cache("Foo", 1).should == 1
    end

    it "should perform a query after ttl has passed" do
      ObjectCache::ClassCacher.cache("Foo", 1)
      Foo.should_receive(:query)
      Timecop.freeze(Time.now+30000) do
        ObjectCache::ClassCacher.cache("Foo", 1)
        Foo.should_not_receive(:query)
        ObjectCache::ClassCacher.cache("Foo", 1)
      end
    end
  end
end
