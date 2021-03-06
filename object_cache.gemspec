# -*- encoding: utf-8 -*-
require File.expand_path('../lib/object_cache/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tom Caspy"]
  gem.email         = ["tcaspy@gmail.com"]
  gem.description   = %q{simple object cache for ruby}
  gem.summary       = %q{hash table for object cache with defined TTL}
  gem.homepage      = "https://github.com/KensoDev/object_cache"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "object_cache"
  gem.require_paths = ["lib"]
  gem.version       = ObjectCache::VERSION

  gem.add_development_dependency(%q<rspec>, [">= 0"])
  gem.add_development_dependency(%q<rake>, ["~> 0.9.2"])
  gem.add_development_dependency(%q<timecop>)
end
