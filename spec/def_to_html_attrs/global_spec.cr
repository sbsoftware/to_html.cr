require "../spec_helper"

module ToHtml::DefToHtmlAttrs::GlobalSpec
  class MyView
    def_to_html do
      div MyAttributeDefiningClass do
        div MyAttributeDefiningObject.new
      end
    end
  end

  class MyAttributeDefiningClass
    self_to_html_attrs do
      anything = "blah"
    end
  end

  class MyAttributeDefiningObject
    def_to_html_attrs do
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
