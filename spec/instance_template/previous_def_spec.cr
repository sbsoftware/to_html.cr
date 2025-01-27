require "../spec_helper"

module ToHtml::PreviousDefSpec
  class View
    ToHtml.instance_template do
      h1 { "First!" }
      yield
    end
  end

  class View
    ToHtml.instance_template do
      previous_def do
        h2 { "Second!" }
        yield
      end
    end
  end

  describe "View#to_html" do
    it "returns the combined HTML of both template definitions" do
      view = View.new

      expected = <<-HTML.squish
      <h1>First!</h1>
      <h2>Second!</h2>
      HTML

      view.to_html { nil }.should eq(expected)
    end
  end
end
