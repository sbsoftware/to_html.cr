require "../spec_helper"

module ToHtml::InstanceTemplate::DoctypeSpec
  class MyView
    ToHtml.instance_template do
      doctype "html"
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      my_view = MyView.new

      expected = <<-HTML.squish
      <!DOCTYPE html>
      HTML

      my_view.to_html.should eq(expected)
    end
  end
end
