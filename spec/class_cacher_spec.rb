require 'spec_helper'

class Foo
  def self.find(ids)
    return ids
  end
end

# we assume the cached objects have ids,
# and for testing we use integers, so we shamelessly fake it :)
class Integer
  def id
    self
  end
end

describe ObjectCache::ClassCacher do
  describe "calling of cache" do

    it "should not perform a query after the object is cached" do
      ObjectCache::ClassCacher.cache("Foo", 1)
      Foo.should_not_receive(:find)
      ObjectCache::ClassCacher.cache("Foo", 1).should == 1
    end

    it "should perform a query after ttl has passed" do
      ObjectCache::ClassCacher.cache("Foo", 1)
      Foo.should_receive(:find).with([1]).and_return([1])
      Timecop.freeze(Time.now+30000) do
        ObjectCache::ClassCacher.cache("Foo", 1).should == 1
        Foo.should_not_receive(:find)
        ObjectCache::ClassCacher.cache("Foo", 1)
      end
    end

    it "should allow caching of multiple objects" do
      ObjectCache::ClassCacher.cache("Foo", [1,2,3]).should == [1,2,3]
    end

    it "should allow caching of multiple objects" do
      ObjectCache::ClassCacher.cache("Foo", [1,2,3])
      Foo.should_not_receive(:find)

      ObjectCache::ClassCacher.cache("Foo", [1,3]).should == [1,3]
    end

    it "should call the find method only for uncached objects" do
      ObjectCache::ClassCacher.cache("Foo", [1,2,3])

      Foo.should_receive(:find).with([4,5]).and_return([4,5])
      ObjectCache::ClassCacher.cache("Foo", [1,3,4,5]).should == [1,3,4,5]

      Foo.should_not_receive(:find)
      ObjectCache::ClassCacher.cache("Foo", [1,2,3,4,5])
    end

  end
end
