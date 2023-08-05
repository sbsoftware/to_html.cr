require "../spec_helper"

module ToHtml::DefToHtmlAttrs::TagGlobalMixSpec
  class MyView
    def_to_html do
      div MyAttributingClass do
        a MyAttributingClass
      end
      div MyAttributingObject.new do
        a MyAttributingObject.new
      end
    end
  end

  class MyAttributingClass
    self_to_html_attrs do
      something = "foo"
      a do
        href = "example.com"
      end
    end
  end

  class MyAttributingObject
    def_to_html_attrs do
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
