require "../spec_helper"

module ToHtml::InstanceTemplate::CaseSpec
  enum Kind
    A
    B
    Other
  end

  class MyView
    getter kind : Kind

    def initialize(@kind)
    end

    ToHtml.instance_template do
      case kind
      when Kind::A
        p { "A" }
      when Kind::B
        div do
          span { "B" }
        end
      else
        i { "Other" }
      end

      div do
        case
        when kind == Kind::A
          strong { "inner-a" }
        else
          em { "inner-not-a" }
        end
      end
    end

    describe "MyView#to_html" do
      it "renders the correct HTML for Kind::A" do
        expected = <<-HTML
        <p>A</p>
        <div>
          <strong>
            inner-a
          </strong>
        </div>
        HTML

        MyView.new(Kind::A).to_html.should eq(expected.squish)
      end

      it "renders the correct HTML for Kind::B" do
        expected = <<-HTML
        <div>
          <span>
            B
          </span>
        </div>
        <div>
          <em>
            inner-not-a
          </em>
        </div>
        HTML

        MyView.new(Kind::B).to_html.should eq(expected.squish)
      end

      it "renders the correct HTML for Kind::Other" do
        expected = <<-HTML
        <i>Other</i>
        <div>
          <em>
            inner-not-a
          </em>
        </div>
        HTML

        MyView.new(Kind::Other).to_html.should eq(expected.squish)
      end
    end
  end
end
