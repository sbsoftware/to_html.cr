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
      div do
        span { "Form" }
        span { my_model.form }
      end
      div do
        span { "Input" }
        span { my_model.input }
      end
    end
  end

  record MyModel, name : String, age : Int32, form : String, input : String

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new(MyModel.new("Stefan", 36, "final", "important!"))

      expected = <<-HTML.squish
      <div>
        <span>Name</span>
        <span>Stefan</span>
      </div>
      <div>
        <span>Age</span>
        <span>36</span>
      </div>
      <div>
        <span>Form</span>
        <span>final</span>
      </div>
      <div>
        <span>Input</span>
        <span>important!</span>
      </div>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
