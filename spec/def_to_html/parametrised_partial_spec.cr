require "../spec_helper"

module ToHtml::DefToHtml::ParametrisedPartialSpec
  class MyView
    def_to_html do
      div do
        MyPartial.new("Bee")
      end
    end
  end

  class MyPartial
    getter content : String

    def initialize(@content)
    end

    def_to_html do
      p { content }
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML
      <div>
        <p>
          Bee
        </p>
      </div>
      HTML

      MyView.new.to_html.should eq(expected)
    end
  end
end
