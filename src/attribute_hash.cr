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
      key = key.to_s
      normalized_key = key.gsub("_", "-")

      if normalized_key.starts_with?("data-") || normalized_key.starts_with?("aria-")
        return if normalized_key == "data-" || normalized_key == "aria-"
        append_attribute(normalized_key, value)
        return
      end

      return unless value

      boolean_attributes << key
    end

    def []=(key, value)
      key = key.to_s
      normalized_key = key.gsub("_", "-")

      if normalized_key.starts_with?("data-") || normalized_key.starts_with?("aria-")
        return if normalized_key == "data-" || normalized_key == "aria-"
        append_prefixed_value(normalized_key, value)
        return
      end

      if key == "data" || key == "aria"
        return if assign_prefixed_hash(key, value)
      end

      append_attribute(key, value)
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

    private def assign_prefixed_hash(prefix : String, value : Hash | NamedTuple) : Bool
      prefix_with_separator = "#{prefix}-"
      value.each do |raw_key, raw_value|
        key = raw_key.to_s.strip.gsub("_", "-")
        next if key.empty? || key == prefix

        if key.starts_with?(prefix_with_separator)
          next if key.size == prefix_with_separator.size

          append_prefixed_value(key, raw_value)
        else
          append_prefixed_value("#{prefix_with_separator}#{key}", raw_value)
        end
      end

      true
    end

    private def assign_prefixed_hash(_prefix : String, _value) : Bool
      false
    end

    # Nested data/aria maps are flattened recursively into hyphen-separated keys.
    private def append_prefixed_value(key : String, value)
      case value
      when Hash, NamedTuple
        value.each do |raw_key, raw_value|
          nested_key_part = raw_key.to_s.strip.gsub("_", "-")
          next if nested_key_part.empty?

          append_prefixed_value("#{key}-#{nested_key_part}", raw_value)
        end
      when Nil
        # Keep data/aria nil behavior aligned with regular attributes: nil never appends.
      else
        append_attribute(key, value)
      end
    end

    private def append_attribute(key : String, value)
      if attributes.has_key?(key)
        attributes[key] += " #{value}" if value
      else
        attributes[key] = value.to_s
      end
    end
  end
end
