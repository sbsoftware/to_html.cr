require "../spec_helper"

module ToHtml::InstanceTemplate::StaticInstanceTemplateSpec
  class MyView
    ToHtml.instance_template do
      html do
        head do
          title { "Title" }
        end
        body do
          p { "Test" }
        end
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML
      <html>
        <head>
          <title>Title</title>
        </head>
        <body>
          <p>Test</p>
        </body>
      </html>
      HTML

      MyView.new.to_html.should eq(expected)
    end
  end
end

