require "../spec_helper"

module ToHtml::InstanceMethodAccessSpec
  class MyView
    def item1
      "Bla!"
    end

    def item2
      "foo"
    end

    def_to_html do
      ol do
        li { item1 }
        li { item2 }
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      expected = <<-HTML
      <ol>
        <li>
          Bla!
        </li>
        <li>
          foo
        </li>
      </ol>
      HTML

      MyView.new.to_html.should eq(expected)
    end
  end
end
