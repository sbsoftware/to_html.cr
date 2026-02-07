module ToHtml
  module AttrEnums
    # Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta/name
    #
    # Note: This intentionally includes both "standard metadata names" as well as
    # commonly-used values from the (non-standard) MetaExtensions wiki.
    enum MetaName
      ApplicationName
      Author
      ColorScheme
      Creator
      Description
      Generator
      Googlebot
      Keywords
      Publisher
      Referrer
      Robots
      ThemeColor
      Viewport

      def to_s : String
        case self
        in ApplicationName
          "application-name"
        in Author
          "author"
        in ColorScheme
          "color-scheme"
        in Creator
          "creator"
        in Description
          "description"
        in Generator
          "generator"
        in Googlebot
          "googlebot"
        in Keywords
          "keywords"
        in Publisher
          "publisher"
        in Referrer
          "referrer"
        in Robots
          "robots"
        in ThemeColor
          "theme-color"
        in Viewport
          "viewport"
        end
      end
    end
  end
end
