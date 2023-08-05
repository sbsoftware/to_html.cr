require "../spec_helper"

module ToHtml::InstanceTemplate::InstanceMethodAccessSpec
  class MyView
    def item1
      "Bla!"
    end

    def item2
      "foo"
    end

    ToHtml.instance_template do
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
