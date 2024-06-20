require "../spec_helper"

module ToHtml::InstanceTemplate::AttributesSpec
  class MyView
    SPECIAL_CSS_CLASSES = [MyCssClass, MyOtherCssClass]
    DEFAULT_VALUE = "two"

    ToHtml.instance_template do
      div MyCssClass, MyOtherCssClass, {"class", "so-unique"}, more_css_classes do
        span(SPECIAL_CSS_CLASSES) { "Blah" }
        img SPECIAL_CSS_CLASSES, more_css_classes
        div MyStimulusController do
          p({"class", "so-special"}) do
            "Some content"
          end
        end
      end

      fieldset do
        label for: SomeId do
          "Options"
        end
        select_tag id: SomeId, name: "myselect" do
          option(value: "", selected: false) { "-" }
          ["one", "two", "three"].each do |val|
            option(value: val, selected: val == DEFAULT_VALUE) { val }
          end
        end
        input name: "name", type: "text", required: true
        input name: "surname", type: "text", required: false
      end
    end

    def more_css_classes
      [MyThirdCssClass, ThatOtherCssClass]
    end
  end

  class MyCssClass
    def self.to_html_attrs(tag, attr_hash)
      attr_hash["class"] = "my-css-class"
    end
  end

  class MyOtherCssClass
    def self.to_html_attrs(tag, attr_hash)
      attr_hash["class"] = "my-other-css-class"
    end
  end

  class MyThirdCssClass
    def self.to_html_attrs(tag, attr_hash)
      attr_hash["class"] = "my-third-css-class"
    end
  end

  class ThatOtherCssClass
    def self.to_html_attrs(tag, attr_hash)
      attr_hash["class"] = "that-other-css-class"
    end
  end

  class MyStimulusController
    def self.to_html_attrs(tag, attr_hash)
      attr_hash["data-controller"] = "my"
      attr_hash["data-action"] = "click->handle_click()"
    end
  end

  class SomeId
    def self.to_s
      "some-id"
    end
  end

  describe "When a template provides object parameters to a tag call" do
    describe "MyView#to_html" do
      it "should return the correct HTML" do
        view = MyView.new

        expected = <<-HTML
        <div class="my-css-class my-other-css-class so-unique my-third-css-class that-other-css-class">
          <span class="my-css-class my-other-css-class">Blah</span>
          <img class="my-css-class my-other-css-class my-third-css-class that-other-css-class">
          <div data-controller="my" data-action="click->handle_click()">
            <p class="so-special">Some content</p>
          </div>
        </div>
        <fieldset>
          <label for="some-id">Options</label>
          <select id="some-id" name="myselect">
            <option value="">-</option>
            <option value="one">one</option>
            <option value="two" selected>two</option>
            <option value="three">three</option>
          </select>
          <input name="name" type="text" required>
          <input name="surname" type="text">
        </fieldset>
        HTML

        view.to_html.should eq(expected.squish)
      end
    end
  end
end
