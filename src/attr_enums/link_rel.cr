module ToHtml
  module AttrEnums
    # Source: https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel
    enum LinkRel
      Alternate
      Author
      Canonical
      CompressionDictionary
      DnsPrefetch
      Expect
      Help
      Icon
      License
      Manifest
      Me
      Modulepreload
      Next
      Pingback
      Preconnect
      Prefetch
      Preload
      Prerender
      Prev
      PrivacyPolicy
      Search
      Stylesheet
      TermsOfService

      def to_s : String
        case self
        in Alternate
          "alternate"
        in Author
          "author"
        in Canonical
          "canonical"
        in CompressionDictionary
          "compression-dictionary"
        in DnsPrefetch
          "dns-prefetch"
        in Expect
          "expect"
        in Help
          "help"
        in Icon
          "icon"
        in License
          "license"
        in Manifest
          "manifest"
        in Me
          "me"
        in Modulepreload
          "modulepreload"
        in Next
          "next"
        in Pingback
          "pingback"
        in Preconnect
          "preconnect"
        in Prefetch
          "prefetch"
        in Preload
          "preload"
        in Prerender
          "prerender"
        in Prev
          "prev"
        in PrivacyPolicy
          "privacy-policy"
        in Search
          "search"
        in Stylesheet
          "stylesheet"
        in TermsOfService
          "terms-of-service"
        end
      end
    end
  end
end
