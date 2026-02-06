module ToHtml
  module AttrEnums
    # Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form#method
    enum FormMethod
      Dialog
      Get
      Post

      def to_s : String
        case self
        in Dialog
          "dialog"
        in Get
          "get"
        in Post
          "post"
        end
      end
    end
  end
end
