require "../../spec_helper"

module ToHtml::InstanceTemplate::Tags::MetaSpec
  class LiteralView
    ToHtml.instance_template do
      meta name: :viewport, content: "width=device-width, initial-scale=1.0"
      meta name: :application_name, content: "MyApp"
      meta name: :theme_color, content: "#ffffff"
      meta name: :googlebot, content: "noindex"
      meta name: "custom", content: "value"
    end
  end

  class DynamicView
    getter theme : String

    def initialize(@theme); end

    ToHtml.instance_template do
      meta name: :theme_color, content: theme
    end
  end

  describe "LiteralView#to_html" do
    it "renders meta[name] using the enum-backed symbol values" do
      expected = <<-HTML.squish
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta name="application-name" content="MyApp">
      <meta name="theme-color" content="#ffffff">
      <meta name="googlebot" content="noindex">
      <meta name="custom" content="value">
      HTML

      LiteralView.new.to_html.should eq(expected)
    end
  end

  describe "DynamicView#to_html" do
    it "typechecks meta[name] even when other attributes are dynamic" do
      DynamicView.new(theme: "#000000").to_html.should eq(%(<meta name="theme-color" content="#000000">))
    end
  end
end
