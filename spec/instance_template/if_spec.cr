require "../spec_helper"

module ToHtml::InstanceTemplate::IfSpec
  class MyView
    getter switch : Bool
    getter option1 : String
    getter option2 : String

    def initialize(@switch, @option1, @option2)
    end

    ToHtml.instance_template do
      if switch
        p { "Hooray!" }
      end
      div do
        if switch
          strong { option1 }
        else
          i { option2 }
        end
      end
      div { "Uff" } if option1.size > 3
      unless switch
        span { "Another one!" }
      end
    end

    describe "MyView#to_html" do
      context "when switch is true" do
        it "should return the correct HTML" do
          # FIXME: Find out where that trailing newline is coming from
          expected = <<-HTML
          <p>Hooray!</p>
          <div>
            <strong>
              Gaga
            </strong>
          </div>
          <div>Uff</div>

          HTML

          MyView.new(true, "Gaga", "Bubu").to_html.should eq(expected.squish)
        end
      end

      context "when switch is false" do
        it "should return the correct HTML" do
          expected = <<-HTML
          <div>
            <i>
              Bubu
            </i>
          </div>
          <div>Uff</div>
          <span>Another one!</span>
          HTML

          MyView.new(false, "Gaga", "Bubu").to_html.should eq(expected.squish)
        end
      end
    end
  end
end
