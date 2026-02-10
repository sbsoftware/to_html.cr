require "../../spec_helper"

module ToHtml::InstanceTemplate::Tags::LinkSpec
  class MyView
    ToHtml.instance_template do
      link href: "style.css", rel: :stylesheet
      link href: "https://example.com", rel: :canonical
      link href: "https://example.com", rel: :dns_prefetch
      link href: "custom", rel: "custom"
      link href: "no-rel.css"
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML.squish
      <link href="style.css" rel="stylesheet">
      <link href="https://example.com" rel="canonical">
      <link href="https://example.com" rel="dns-prefetch">
      <link href="custom" rel="custom">
      <link href="no-rel.css">
      HTML

      view.to_html.should eq(expected)
    end
  end
end
