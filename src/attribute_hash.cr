module ToHtml
  # :nodoc:
  class AttributeHash
    getter attributes : Hash(String, String)
    getter boolean_attributes : Array(String)
    @explicit_prefixed_attributes : Hash(String, Bool)

    def initialize
      @attributes = {} of String => String
      @boolean_attributes = [] of String
      @explicit_prefixed_attributes = {} of String => Bool
    end

    def []=(key, value : Bool)
      key = key.to_s

      if prefixed_key = normalize_explicit_prefixed_key(key)
        set_prefixed_attribute(prefixed_key, value.to_s, explicit: true)
        return
      end

      return unless value

      boolean_attributes << key
    end

    def []=(key, value)
      key = key.to_s

      if prefixed_key = normalize_explicit_prefixed_key(key)
        serialized_value = serialize_prefixed_value(value)

        if serialized_value
          set_prefixed_attribute(prefixed_key, serialized_value, explicit: true)
        else
          clear_prefixed_attribute(prefixed_key, explicit: true)
        end

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
      # Keep precedence deterministic: explicit data-*/aria-* keys win over hash entries.
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

      serialized_value = serialize_prefixed_value(raw_value)
      if serialized_value
        set_prefixed_attribute(prefixed_key, serialized_value, explicit: false)
      else
        clear_prefixed_attribute(prefixed_key, explicit: false)
      end
    end

    private def normalize_explicit_prefixed_key(key : String) : String?
      if key.starts_with?("data-") || key.starts_with?("data_")
        normalize_explicit_prefixed_key("data", key)
      elsif key.starts_with?("aria-") || key.starts_with?("aria_")
        normalize_explicit_prefixed_key("aria", key)
      end
    end

    private def normalize_explicit_prefixed_key(prefix : String, key : String) : String?
      key = key.gsub("_", "-")
      prefix_with_separator = "#{prefix}-"
      return unless key.starts_with?(prefix_with_separator)

      suffix = key.byte_slice(prefix_with_separator.bytesize, key.bytesize - prefix_with_separator.bytesize)
      return if suffix.empty?

      "#{prefix_with_separator}#{suffix}"
    end

    private def normalize_prefixed_hash_key(prefix : String, raw_key) : String?
      key = raw_key.to_s.strip
      return if key.empty?

      key = key.gsub("_", "-")
      prefix_with_separator = "#{prefix}-"
      if key.starts_with?(prefix_with_separator)
        suffix = key.byte_slice(prefix_with_separator.bytesize, key.bytesize - prefix_with_separator.bytesize)
        return if suffix.empty?

        return "#{prefix_with_separator}#{suffix}"
      end
      return if key == prefix

      "#{prefix_with_separator}#{key}"
    end

    private def serialize_prefixed_value(value : Nil) : String?
      nil
    end

    private def serialize_prefixed_value(value : Bool) : String?
      value.to_s
    end

    private def serialize_prefixed_value(value : Number) : String?
      value.to_s
    end

    private def serialize_prefixed_value(value : String) : String?
      value
    end

    private def serialize_prefixed_value(value) : String?
      value.to_s
    end

    private def set_prefixed_attribute(key : String, value : String, explicit : Bool)
      @explicit_prefixed_attributes[key] = true if explicit
      return if !explicit && @explicit_prefixed_attributes[key]?

      attributes[key] = value
    end

    private def clear_prefixed_attribute(key : String, explicit : Bool)
      @explicit_prefixed_attributes[key] = true if explicit
      return if !explicit && @explicit_prefixed_attributes[key]?

      attributes.delete(key)
    end
  end
end
