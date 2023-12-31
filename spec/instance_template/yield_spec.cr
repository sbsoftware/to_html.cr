require "../spec_helper"

module ToHtml::InstanceTemplate::YieldSpec
  class Layout
    getter site_title : String

    def initialize(@site_title)
    end

    ToHtml.instance_template do
      html do
        head do
          title { site_title }
        end
        body do
          yield
        end
      end
    end
  end

  class View
    ToHtml.class_template do
      h1 { "Hello" }
      p do
        "A few things to mention"
      end
    end
  end

  describe "Layout#to_html called with a block" do
    it "should return the correct HTML" do
      layout = Layout.new("Hi")

      expected = <<-HTML
      <html>
        <head>
          <title>
            Hi
          </title>
        </head>
        <body>
          <h1>Hello</h1>
          <p>A few things to mention</p>
        </body>
      </html>
      HTML

      layout.to_html do |io, indent_level|
        View.to_html(io, indent_level)
      end.should eq(expected.squish)
    end
  end
end
