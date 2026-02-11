require "../spec_helper"

module ToHtml::InstanceTemplate::IteratorBlocksSpec
  class IndexedItem
    getter value : String

    def initialize(@value)
    end

    ToHtml.instance_template do
      em { value }
    end
  end

  class IndexedList
    getter items : Array(String)

    def initialize(@items)
    end

    ToHtml.instance_template do
      ul do
        items.each_with_index do |item, idx|
          li do
            if idx.even?
              span { idx.to_s }
            else
              IndexedItem.new(item)
            end

            unless idx == items.size - 1
              small { "present" }
            end
          end
        end
      end
    end
  end

  class TimesList
    ToHtml.instance_template do
      ol do
        3.times do |i|
          li do
            if i.even?
              "even"
            else
              "odd"
            end
          end
        end

        2.times do
          li { "tail" }
        end
      end
    end
  end

  describe "iterator blocks" do
    it "supports each_with_index with nested template control flow" do
      expected = <<-HTML
      <ul>
        <li>
          <span>
            0
          </span>
          <small>present</small>
        </li>
        <li>
          <em>
            two
          </em>
        </li>
      </ul>
      HTML

      IndexedList.new(["one", "two"]).to_html.should eq(expected.squish)
    end

    it "supports times with and without block args" do
      expected = <<-HTML
      <ol>
        <li>even</li>
        <li>odd</li>
        <li>even</li>
        <li>tail</li>
        <li>tail</li>
      </ol>
      HTML

      TimesList.new.to_html.should eq(expected.squish)
    end
  end
end
