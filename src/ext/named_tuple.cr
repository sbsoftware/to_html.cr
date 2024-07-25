struct NamedTuple
  def to_html_attrs(_tag, attr_hash)
    each do |key, value|
      attr_hash[key.to_s] = value
    end
  end
end
