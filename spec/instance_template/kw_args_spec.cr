require "../spec_helper"

module ToHtml::InstanceTemplate::KwArgsSpec
  class MyView
    ToHtml.instance_template do
      a href: "https://www.example.com" do
        "example.com"
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML
      <a href="https://www.example.com">example.com</a>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
