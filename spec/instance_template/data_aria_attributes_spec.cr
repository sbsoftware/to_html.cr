require "../spec_helper"

module ToHtml::InstanceTemplate::DataAriaAttributesSpec
  class BasicView
    ToHtml.instance_template do
      div data: {foo: "bar"}, aria: {label: "X"}
    end
  end

  class TypeView
    ToHtml.instance_template do
      div data: {enabled: true, count: 7, ratio: 2.5, ignored: nil}, aria: {hidden: false, current: nil}
    end
  end

  class ProviderAttrs
    ToHtml.class_tag_attrs do
      data = {foo: "provider-hash", bar: 1}
      aria = {label: "provider-label"}
      data_foo = "provider-explicit"
      aria_label = "provider-explicit-label"
    end
  end

  class MergeView
    ToHtml.instance_template do
      attrs = [
        ProviderAttrs,
        {data: {foo: "array-hash", baz: true}, aria: {label: "array-label", hidden: false}},
      ]

      div attrs, {"data-foo", "tuple-explicit"}, {"aria-label", "tuple-explicit-label"},
        data_foo: "named-explicit",
        aria_label: "named-explicit-label",
        data: {"foo" => "named-hash-last", "count" => 2.5, "bar" => nil, "data-prefixed" => "normalized"},
        aria: {"label" => "named-label-last", "current" => false, "omitted" => nil}
    end
  end

  class NormalizeView
    ToHtml.instance_template do
      div data: {"foo_bar" => "snake", :"foo-baz" => "dash", :"data-qux" => "prefixed"},
        aria: {"labelled_by" => "target", :"aria-described-by" => "description"}
    end
  end

  class NestedView
    ToHtml.instance_template do
      div data: {foo: {blah: "baz"}}, aria: {label: {text: "X"}}
    end
  end

  describe "data/aria attribute expansion" do
    it "expands data and aria named tuple attributes" do
      BasicView.new.to_html.should eq(%(<div data-foo="bar" aria-label="X"></div>))
    end

    it "serializes bool and numbers while omitting nil values" do
      TypeView.new.to_html.should eq(%(<div data-enabled="true" data-count="7" data-ratio="2.5" aria-hidden="false"></div>))
    end

    it "merges array, tuple, to_html_attrs, and named args with last-write-wins semantics" do
      MergeView.new.to_html.should eq(%(<div data-foo="named-hash-last" aria-label="named-label-last" data-baz="true" aria-hidden="false" data-count="2.5" data-prefixed="normalized" aria-current="false"></div>))
    end

    it "normalizes symbol and string keys for data/aria hashes" do
      NormalizeView.new.to_html.should eq(%(<div data-foo-bar="snake" data-foo-baz="dash" data-qux="prefixed" aria-labelled-by="target" aria-described-by="description"></div>))
    end

    it "flattens nested data/aria hashes and named tuples" do
      NestedView.new.to_html.should eq(%(<div data-foo-blah="baz" aria-label-text="X"></div>))
    end
  end
end
