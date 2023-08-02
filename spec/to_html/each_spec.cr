require "../spec_helper"

module ToHtml::EachSpec
  class List
    getter items : Array(String)

    def initialize(@items)
    end

    def_to_html do
      ul do
        items.each do |item|
          Item.new(item)
        end
      end
    end
  end

  class Item
    getter name : String

    def initialize(@name)
    end

    def_to_html do
      li { name }
    end
  end

  describe "List#to_html" do
    it "should return the correct HTML" do
      list = List.new(["one", "two", "three"])

      expected = <<-HTML
      <ul>
        <li>
          one
        </li>
        <li>
          two
        </li>
        <li>
          three
        </li>
      </ul>
      HTML

      list.to_html.should eq(expected)
    end
  end
end
