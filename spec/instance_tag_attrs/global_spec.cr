require "../spec_helper"

module ToHtml::InstanceTagAttrs::GlobalSpec
  class MyView
    ToHtml.instance_template do
      div MyAttributeDefiningClass do
        div MyAttributeDefiningObject.new
      end
    end
  end

  class MyAttributeDefiningClass
    ToHtml.class_tag_attrs do
      anything = "blah"
    end
  end

  class MyAttributeDefiningObject
    ToHtml.instance_tag_attrs do
      something = "foo"
      data_controller = "my-ctrl"
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML
      <div anything="blah">
        <div something="foo" data-controller="my-ctrl"></div>
      </div>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
