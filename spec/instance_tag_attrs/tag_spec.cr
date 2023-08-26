require "../spec_helper"

module ToHtml::InstanceTagAttrs::TagSpec
  class MyView
    ToHtml.instance_template do
      div MyLinkAttributeClass do
        a MyLinkAttributeClass do
          img MyLinkAttributeClass
        end
      end
      div MyLinkAttributeObject.new do
        a MyLinkAttributeObject.new do
          img MyLinkAttributeObject.new
        end
      end
    end
  end

  class MyLinkAttributeClass
    ToHtml.class_tag_attrs do
      a do
        href = "https://www.example.com"
      end
      img do
        src = "https://www.example.com/img.jpg"
        alt = "An image of this"
      end
    end
  end

  class MyLinkAttributeObject
    ToHtml.instance_tag_attrs do
      a do
        href = "https://example.com"
      end
      img do
        src = "https://example.com/img.jpg"
        alt = "Another image of this"
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML
      <div>
        <a href="https://www.example.com">
          <img src="https://www.example.com/img.jpg" alt="An image of this">
        </a>
      </div>
      <div>
        <a href="https://example.com">
          <img src="https://example.com/img.jpg" alt="Another image of this">
        </a>
      </div>
      HTML

      view.to_html.should eq(expected.squish)
    end
  end
end
