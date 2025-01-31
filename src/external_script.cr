module ToHtml
  class ExternalScript
    getter url : String

    def initialize(@url); end

    ToHtml.instance_tag_attrs do
      src = url
    end

    ToHtml.instance_template do
      script self
    end
  end
end
