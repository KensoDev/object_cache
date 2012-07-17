require 'yaml'

class ObjectCache
  class Reader
    attr_accessor :hash

    def initialize(source)

      case source
      when nil
        raise Errno::ENOENT, "No file specified as ObjectCache source"
      when Hash
        self.hash = source
      else
        self.hash = YAML.load(ERB.new(open(source).read).result).to_hash
      end

    end

    #creates a hashed key-value by the class names
    def grouped_objects
      product = {}
      hash.each do |key,value|
        product[value["name"]] ||= []
        product[value["name"]] << [key, value["id"]]
      end
      product
    end

  end
end