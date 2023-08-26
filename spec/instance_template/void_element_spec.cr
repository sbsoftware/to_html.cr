require "../spec_helper"

module ToHtml::InstanceTemplate::VoidElementSpec
  class MyView
    ToHtml.class_template do
      div do
        span { "First line" }
        br
        span { "Second line" }
        hr
        embed MyVideo.new("/media/video.mp4")
        hr
        form action: "/inputs", method: "POST" do
          input MyInputField.new("foo"), placeholder: "bar"
          input type: "submit", name: "submit", value: "Submit"
        end
      end
    end
  end

  class MyVideo
    getter path : String

    def initialize(@path); end

    ToHtml.instance_tag_attrs do
      type = "video/webm"
      src = path
      width = "250"
      height = "200"
    end
  end

  class MyInputField
    getter field_value : String

    def initialize(@field_value); end

    ToHtml.instance_tag_attrs do
      type = "text"
      name = "name"
      value = field_value
    end
  end

  describe "MyView.to_html" do
    it "should render void elements correctly" do
      expected = <<-HTML.squish
      <div>
        <span>First line</span>
        <br>
        <span>Second line</span>
        <hr>
        <embed type="video/webm" src="/media/video.mp4" width="250" height="200">
        <hr>
        <form action="/inputs" method="POST">
          <input type="text" name="name" value="foo" placeholder="bar">
          <input type="submit" name="submit" value="Submit">
        </form>
      </div>
      HTML

      MyView.to_html.should eq(expected)
    end
  end
end
