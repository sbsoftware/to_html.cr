require "markout"

module ToHtml
  module Benchmark
    class MarkoutTemplate
      include Markout::Component

      def initialize
        render("foo", ["Peter", "Paul", "Mary"])
      end

      def render(some_string, names)
        h1 "Benchmark"

        h2 "Long Text"

        div class: "long-text" do
          p do
            text "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
          end
        end

        h2 "Deeply Nested"
        div class: "some" do
          div class: "deeply" do
            div class: "nested", foo: "bar" do
              div class: "but" do
                div class: "still" do
                  div class: "very" do
                    div class: "interesting", bar: "foo" do
                      div class: "html" do
                        div class: "elements" do
                          div class: "isnt" do
                            div class: "that" do
                              span "beautiful"
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end

        h2 "Method Call"
        div class: "method-call" do
          span some_string
        end

        h2 "Iteration"
        ul do
          names.each do |name|
            li name
          end
        end
      end
    end
  end
end
