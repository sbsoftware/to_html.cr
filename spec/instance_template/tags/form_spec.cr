require "../../spec_helper"

module ToHtml::InstanceTemplate::Tags::FormSpec
  class MyView
    ToHtml.instance_template do
      form method: :dialog
      form method: :get
      form method: :post
      form method: "foo"
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML.squish
      <form method="dialog"></form>
      <form method="get"></form>
      <form method="post"></form>
      <form method="foo"></form>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
