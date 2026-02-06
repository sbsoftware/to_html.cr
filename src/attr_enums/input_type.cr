module ToHtml
  module AttrEnums
    # Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#input_types
    enum InputType
      Button
      Checkbox
      Color
      Date
      DatetimeLocal
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

      def to_s : String
        case self
        in Button
          "button"
        in Checkbox
          "checkbox"
        in Color
          "color"
        in Date
          "date"
        in DatetimeLocal
          "datetime-local"
        in Email
          "email"
        in File
          "file"
        in Hidden
          "hidden"
        in Image
          "image"
        in Month
          "month"
        in Number
          "number"
        in Password
          "password"
        in Radio
          "radio"
        in Range
          "range"
        in Reset
          "reset"
        in Search
          "search"
        in Submit
          "submit"
        in Tel
          "tel"
        in Text
          "text"
        in Time
          "time"
        in Url
          "url"
        in Week
          "week"
        end
      end
    end
  end
end
