require "../spec_helper"

module ToHtml::InstanceTemplate::ChainedMethodCallsSpec
  class MyView
    getter my_model : MyModel

    def initialize(@my_model)
    end

    ToHtml.instance_template do
      div do
        span { "Name" }
        span { my_model.name }
      end
      div do
        span { "Age" }
        span { my_model.age }
      end
    end
  end

  record MyModel, name : String, age : Int32

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new(MyModel.new("Stefan", 36))

      expected = <<-HTML
      <div>
        <span>Name</span>
        <span>
          Stefan
        </span>
      </div>
      <div>
        <span>Age</span>
        <span>
          36
        </span>
      </div>
      HTML

      view.to_html.should eq(expected.squish)
    end
  end
end
