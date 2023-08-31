module ToHtml
  module AttrEnums
    # Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#input_types
    enum InputType
      Button
      Checkbox
      Color
      Date
      # NOTE: Leaving this one out because it would only match the symbol with an underscore
      #       while it actually needs a hyphen: "datetime-local". Use a string instead of the
      #       symbol if you need this type.
      # DatetimeLocal
      Email
      File
      Hidden
      Image
      Month
      Number
      Password
      Radio
      Range
      Reset
      Search
      Submit
      Tel
      Text
      Time
      Url
      Week
    end
  end
end
