require "./spec_helper"

module ToHtml::LayoutSpec
  class Something
    def window_title
      "Surprise!"
    end

    def return_it!
      42
    end
  end

  class MyStyle
    ToHtml.class_template do
      style do
        <<-CSS.squish
        body {
          background-color: #EEEEEE;
        }
        CSS
      end
    end
  end

  class MyScript
    ToHtml.class_template do
      script do
        <<-JS
        console.log("Hello World!");
        JS
      end
    end
  end

  class MyId
    ToHtml.class_tag_attrs do
      id = "the-id"
    end
  end

  class OtherAttrs
    ToHtml.class_tag_attrs do
      style = "background-color: red;"
    end
  end

  class MyLayout < Layout
    getter something : Something

    delegate :window_title, to: something

    append_to_head MyStyle
    prepend_to_head MyScript
    body_attributes MyId
    body_attributes OtherAttrs

    ToHtml.instance_template do
      super do
        div { something.return_it! }
      end
    end
  end

  describe "MyLayout" do
    it "renders the correct HTML" do
      something = Something.new
      layout = MyLayout.new(something: something)

      expected = <<-HTML.squish
      <!DOCTYPE html>
      <html>
        <head>
          <title>Surprise!</title>
          <meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1.0">
          <script>
          console.log("Hello World!");
          </script>
          <style>
          body {
            background-color: #EEEEEE;
          }
          </style>
        </head>
        <body id="the-id" style="background-color: red;">
          <div>42</div>
        </body>
      </html>
      HTML

      layout.to_html.should eq(expected)
    end
  end
end
