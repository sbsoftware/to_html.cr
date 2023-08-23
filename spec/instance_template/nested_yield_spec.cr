require "../spec_helper"

module ToHtml::InstanceTemplate::NestedYieldSpec
  class Page
    def some_component
      @some_component ||= MyComponent.new("The Page")
    end

    ToHtml.instance_template do
      main do
        some_component.to_html do
          p { "First inner content!" }
        end
      end
      aside do
        MyComponent.new("Title").to_html do
          div { "Didn't expect that, hu?" }
          some_component.to_html do
            p { "Second inner content!" }
          end
        end
      end
    end
  end

  class MyComponent
    getter heading : String

    def initialize(@heading)
    end

    ToHtml.instance_template do
      section do
        h3 { heading }
        yield
      end
    end
  end

  describe "Page#to_html" do
    it "should return the correct HTML" do
      page = Page.new

      expected = <<-HTML.squish
      <main>
        <section>
          <h3>The Page</h3>
          <p>First inner content!</p>
        </section>
      </main>
      <aside>
        <section>
          <h3>Title</h3>
          <div>Didn't expect that, hu?</div>
          <section>
            <h3>The Page</h3>
            <p>Second inner content!</p>
          </section>
        </section>
      </aside>
      HTML

      page.to_html.should eq(expected)
    end
  end
end
