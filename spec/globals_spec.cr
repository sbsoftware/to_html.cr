require "./spec_helper"
require "../src/globals"

module ToHtml::GlobalsSpec
  class MyView
    instance_template do
      div AttributesClass do
        a AttributesClass.new do
          "Foo"
        end
      end
    end

    class_template do
      div AttributesClass do
        a AttributesClass.new do
          "Bar"
        end
      end
    end
  end

  class AttributesClass
    class_tag_attrs do
      some = "thing"
    end

    instance_tag_attrs do
      ding = "dong"
    end
  end

  describe "MyView.to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML
      <div some="thing">
        <a ding="dong">Bar</a>
      </div>
      HTML

      MyView.to_html.should eq(expected.squish)
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML
      <div some="thing">
        <a ding="dong">Foo</a>
      </div>
      HTML

      view.to_html.should eq(expected.squish)
    end
  end
end
