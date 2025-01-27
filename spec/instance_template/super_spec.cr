require "../spec_helper"

module ToHtml::SuperSpec
  class Parent
    ToHtml.instance_template do
      h1 { "Parent!" }
      div do
        yield
      end
    end
  end

  class Child < Parent
    ToHtml.instance_template do
      super do
        h2 { "Child!" }
      end
    end
  end

  describe "Child#to_html" do
    it "returns the combined HTML of both classes" do
      child = Child.new

      expected = <<-HTML.squish
      <h1>Parent!</h1>
      <div>
        <h2>Child!</h2>
      </div>
      HTML

      child.to_html.should eq(expected)
    end
  end
end
