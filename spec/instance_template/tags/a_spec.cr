require "../../spec_helper"

module ToHtml::InstanceTemplate::Tags::ASpec
  class MyView
    ToHtml.instance_template do
      a href: "https://example.com", rel: :alternate
      a href: "https://example.com", rel: :external
      a href: "https://example.com", rel: :nofollow
      a href: "https://example.com", rel: :privacy_policy
      a href: "https://example.com", rel: :terms_of_service
      a href: "https://example.com", rel: "custom"
      a href: "https://example.com"
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML.squish
      <a href="https://example.com" rel="alternate"></a>
      <a href="https://example.com" rel="external"></a>
      <a href="https://example.com" rel="nofollow"></a>
      <a href="https://example.com" rel="privacy-policy"></a>
      <a href="https://example.com" rel="terms-of-service"></a>
      <a href="https://example.com" rel="custom"></a>
      <a href="https://example.com"></a>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
