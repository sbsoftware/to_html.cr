require "../spec_helper"

module ToHtml::InstanceTagAttrs::TagGlobalMixSpec
  class MyView
    ToHtml.instance_template do
      div MyAttributingClass do
        a MyAttributingClass
      end
      div MyAttributingObject.new do
        a MyAttributingObject.new
      end
    end
  end

  class MyAttributingClass
    ToHtml.class_tag_attrs do
      something = "foo"
      a do
        href = "example.com"
      end
    end
  end

  class MyAttributingObject
    ToHtml.instance_tag_attrs do
      something = "foo"
      a do
        href = "example.com"
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML
      <div something="foo">
        <a something="foo" href="example.com"></a>
      </div>
      <div something="foo">
        <a something="foo" href="example.com"></a>
      </div>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
