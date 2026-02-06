module ToHtml
  module AttrEnums
    # Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel
    enum AnchorRel
      Alternate
      Author
      Bookmark
      External
      Help
      License
      Me
      Next
      Nofollow
      Noopener
      Noreferrer
      Opener
      Prev
      PrivacyPolicy
      Search
      Tag
      TermsOfService

      def to_s : String
        case self
        in Alternate
          "alternate"
        in Author
          "author"
        in Bookmark
          "bookmark"
        in External
          "external"
        in Help
          "help"
        in License
          "license"
        in Me
          "me"
        in Next
          "next"
        in Nofollow
          "nofollow"
        in Noopener
          "noopener"
        in Noreferrer
          "noreferrer"
        in Opener
          "opener"
        in Prev
          "prev"
        in PrivacyPolicy
          "privacy-policy"
        in Search
          "search"
        in Tag
          "tag"
        in TermsOfService
          "terms-of-service"
        end
      end
    end
  end
end
