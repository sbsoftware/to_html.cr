require "html_builder"

module ToHtml
  module Benchmark
    class HtmlBuilderTemplate
      def some_string
        "foo"
      end

      def names
        ["Peter", "Paul", "Mary"]
      end

      def to_s(io)
        io << HTML.build do
          h1 { text "Benchmark" }

          h2 { text "Long Text" }

          div(class: "long-text") do
            p do
              text "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
            end
          end

          h2 { text "Deeply Nested" }
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
                                span { text "beautiful" }
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

          h2 { text "Method Call" }
          div class: "method-call" do
            span { text some_string }
          end

          h2 { text "Iteration" }
          ul do
            names.each do |name|
              li { text name }
            end
          end
        end
      end
    end
  end
end
