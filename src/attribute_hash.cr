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

      if prefixed_key = normalize_explicit_prefixed_key(key)
        attributes[prefixed_key] = value.to_s
        return
      end

      return unless value

      boolean_attributes << key
    end

    def []=(key, value)
      key = key.to_s

      if prefixed_key = normalize_explicit_prefixed_key(key)
        assign_prefixed_value(prefixed_key, value)
        return
      end

      if prefix = prefixed_hash_prefix(key)
        return if assign_prefixed_hash(prefix, value)
      end

      if attributes.has_key?(key)
        attributes[key] += " #{value}" if value
      else
        attributes[key] = value.to_s
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

    private def prefixed_hash_prefix(key : String) : String?
      return "data" if key == "data"
      return "aria" if key == "aria"

      nil
    end

    private def assign_prefixed_hash(prefix : String, value : NamedTuple) : Bool
      # Hash-style data/aria attributes are expanded into their explicit key form.
      value.each do |raw_key, raw_value|
        assign_prefixed_hash_entry(prefix, raw_key, raw_value)
      end

      true
    end

    private def assign_prefixed_hash(prefix : String, value : Hash) : Bool
      # Merge order is deterministic because keys are written in encounter order.
      value.each do |raw_key, raw_value|
        assign_prefixed_hash_entry(prefix, raw_key, raw_value)
      end

      true
    end

    private def assign_prefixed_hash(_prefix : String, _value) : Bool
      false
    end

    private def assign_prefixed_hash_entry(prefix : String, raw_key, raw_value)
      prefixed_key = normalize_prefixed_hash_key(prefix, raw_key)
      return unless prefixed_key

      assign_prefixed_value(prefixed_key, raw_value)
    end

    private def normalize_explicit_prefixed_key(key : String) : String?
      key = key.gsub("_", "-")

      if key.starts_with?("data-")
        suffix = key.byte_slice(5, key.bytesize - 5)
        return if suffix.empty?

        "data-#{suffix}"
      elsif key.starts_with?("aria-")
        suffix = key.byte_slice(5, key.bytesize - 5)
        return if suffix.empty?

        "aria-#{suffix}"
      end
    end

    private def normalize_prefixed_hash_key(prefix : String, raw_key) : String?
      key = normalize_prefixed_hash_key_part(raw_key)
      return unless key

      prefix_with_separator = "#{prefix}-"
      if key.starts_with?(prefix_with_separator)
        suffix = key.byte_slice(prefix_with_separator.bytesize, key.bytesize - prefix_with_separator.bytesize)
        return if suffix.empty?

        return "#{prefix_with_separator}#{suffix}"
      end
      return if key == prefix

      "#{prefix_with_separator}#{key}"
    end

    private def normalize_prefixed_hash_key_part(raw_key) : String?
      key = raw_key.to_s.strip
      return if key.empty?

      key.gsub("_", "-")
    end

    # Nested data/aria maps are flattened recursively into hyphen-separated keys.
    private def assign_prefixed_value(key : String, value : NamedTuple)
      value.each do |raw_key, raw_value|
        nested_key_part = normalize_prefixed_hash_key_part(raw_key)
        next unless nested_key_part

        assign_prefixed_value("#{key}-#{nested_key_part}", raw_value)
      end
    end

    private def assign_prefixed_value(key : String, value : Hash)
      value.each do |raw_key, raw_value|
        nested_key_part = normalize_prefixed_hash_key_part(raw_key)
        next unless nested_key_part

        assign_prefixed_value("#{key}-#{nested_key_part}", raw_value)
      end
    end

    private def assign_prefixed_value(key : String, value)
      serialized_value = serialize_prefixed_value(value)
      if serialized_value
        attributes[key] = serialized_value
      else
        attributes.delete(key)
      end
    end

    private def serialize_prefixed_value(value : Nil) : String?
      nil
    end

    private def serialize_prefixed_value(value) : String?
      value.to_s
    end
  end
end
