require "../spec_helper"

module ToHtml::ExternalScriptSpec
  class MyView
    ToHtml.class_template do
      html do
        head do
          ExternalScript.new("https://example.com/example.js")
          script ExternalScript.new("https://example.com/example2.js")
        end
      end
    end
  end

  describe "MyView.to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML.squish
      <html>
        <head>
          <script src="https://example.com/example.js"><script>
          <script src="https://example.com/example2.js"></script>
        </head>
      </html>
      HTML
    end
  end
end
