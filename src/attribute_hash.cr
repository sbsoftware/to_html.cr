module ToHtml
  # :nodoc:
  class AttributeHash
    getter attributes : Hash(String, String)

    delegate :empty?, to: attributes

    def initialize
      @attributes = {} of String => String
    end

    def []=(key, value)
      if attributes.has_key?(key)
        attributes[key] += " #{value}"
      else
        attributes[key] = value
      end
    end

    def to_s(io)
      attributes.each_with_index do |(key, value), index|
        io << key
        io << "=\""
        io << value
        io << "\""
        io << " " unless index == attributes.size - 1
      end
    end
  end
end
