require "../spec_helper"

module ToHtml::InstanceTemplate::KwArgsSpec
  class MyView
    ToHtml.instance_template do
      a href: "https://www.example.com" do
        "example.com"
      end
      a href: Paths.some_uri do
        "Test"
      end
      img src: Paths.other_uri
    end
  end

  module Paths
    extend self

    def some_uri
      "https://some.example.com"
    end

    def other_uri
      "https://example.com/test.png"
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML.squish
      <a href="https://www.example.com">example.com</a>
      <a href="https://some.example.com">Test</a>
      <img src="https://example.com/test.png">
      HTML

      view.to_html.should eq(expected.squish)
    end
  end
end
