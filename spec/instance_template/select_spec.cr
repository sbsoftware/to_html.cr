require "../spec_helper"

module ToHtml::InstanceTemplate::SelectSpec
  class MyView
    ToHtml.class_template do
      form do
        select_tag name: "test" do
          option(value: "1") { "One" }
          option(value: "2") { "Two" }
        end
      end
    end
  end

  describe "MyView.to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML.squish
      <form>
        <select name="test">
          <option value="1">One</option>
          <option value="2">Two</option>
        </select>
      </form>
      HTML

      MyView.to_html.should eq(expected)
    end
  end
end
