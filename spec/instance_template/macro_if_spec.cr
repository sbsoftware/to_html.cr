require "../spec_helper"

module ToHtml::InstanceTemplate::MacroIfSpec
  class MyView
    ToHtml.class_template do
      {% if false %}
        p do
          "Not shown"
        end
      {% else %}
        p do
          "Shown"
        end
      {% end %}
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML.squish
      <p>Shown</p>
      HTML

      MyView.to_html.should eq(expected)
    end
  end
end
