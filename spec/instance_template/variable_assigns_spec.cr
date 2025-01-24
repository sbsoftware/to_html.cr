require "../spec_helper"

module ToHtml::InstanceTemplate::VariableAssignsSpec
  class MyView
    def something_expensive
      ["expensive", "strings"]
    end

    ToHtml.instance_template do
      tmp = something_expensive
      tmp.each do |item|
        div { item }
      end
    end
  end

  describe "MyView#to_html" do
    it "should not render the variable assignment" do
      expected = <<-HTML.squish
      <div>expensive</div>
      <div>strings</div>
      HTML

      MyView.new.to_html.should eq(expected)
    end
  end
end
