require 'spec_helper'

describe ObjectCache do

  describe "reading the yml file" do
    it "should read yml to a hash" do
      o=ObjectCache::Reader.new(File.dirname(__FILE__)+"/fixtures/foo.yml")
      o.hash.class.should == Hash
    end
  end

  describe "caching" do
    before :all do
      @hash = {
        foo: {
          "name" => "User",
          "id" => 1
        },
        bar: {
          "name" => "User",
          "id" => 2
        },
        baz: {
          "name" => "Blah",
          "id" => 4
        }
      }

      ObjectCache.source @hash

      class User
      end

      class Blah
      end
    end

    it "should cache all of the objects in the hash" do
      u1 = double(User)
      u2 = double(User)
      u1.stub!(:id).and_return(1)
      u2.stub!(:id).and_return(2)
      b = double(Blah)
      b.stub!(:id).and_return(10)
      User.should_receive(:find).with([1,2]).and_return([u1,u2])
      Blah.should_receive(:find).with([4]).and_return([b])

      ObjectCache.foo.should == u1
    end
  end

end