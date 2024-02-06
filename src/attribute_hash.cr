module ToHtml
  # :nodoc:
  class AttributeHash
    getter attributes : Hash(String, String)
    getter boolean_attributes : Array(String)

    def initialize
      @attributes = {} of String => String
      @boolean_attributes = [] of String
    end

    def []=(key, value : Bool)
      return unless value

      boolean_attributes << key
    end

    def []=(key, value)
      if attributes.has_key?(key)
        attributes[key] += " #{value}"
      else
        attributes[key] = value
      end
    end

    def empty?
      attributes.empty? && boolean_attributes.empty?
    end

    def to_s(io)
      attributes.each_with_index do |(key, value), index|
        io << key
        io << "=\""
        io << value
        io << "\""
        io << " " unless index == attributes.size - 1
      end
      io << " " if boolean_attributes.any?
      boolean_attributes.join(io, " ")
    end
  end
end
