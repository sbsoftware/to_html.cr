require "../spec_helper"

module ToHtml::InstanceTemplate::MacroForSpec
  class MyView
    getter a : String
    getter b : String

    def initialize(@a, @b); end

    ToHtml.instance_template do
      form do
        {% for ivar in @type.instance_vars %}
          input type: :text, name: {{ivar.name.stringify}}, value: {{ivar.name.id}}
        {% end %}
      end
    end
  end

  class MyLabelledView
    getter a : String
    getter b : String

    def initialize(@a, @b); end

    ToHtml.instance_template do
      form do
        {% for ivar in @type.instance_vars %}
          label for: {{ivar.name.stringify}} do
            {{ivar.name.stringify}}
          end

          input type: :text, name: {{ivar.name.stringify}}, value: {{ivar.name.id}}
        {% end %}
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML.squish
      <form>
        <input type="text" name="a" value="foo">
        <input type="text" name="b" value="bar">
      </form>
      HTML

      MyView.new(a: "foo", b: "bar").to_html.should eq(expected)
    end
  end

  describe "MyLabelledView#to_html" do
    it "supports multiple expressions in a macro-for body" do
      expected = <<-HTML.squish
      <form>
        <label for="a">a</label>
        <input type="text" name="a" value="foo">
        <label for="b">b</label>
        <input type="text" name="b" value="bar">
      </form>
      HTML

      MyLabelledView.new(a: "foo", b: "bar").to_html.should eq(expected)
    end
  end
end
