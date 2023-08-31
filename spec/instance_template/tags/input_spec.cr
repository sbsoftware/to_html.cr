require "../../spec_helper"

module ToHtml::InstanceTemplate::Tags::InputSpec
  class MyView
    ToHtml.instance_template do
      form do
        input type: :button
        input type: :checkbox
        input type: :color
        input type: :date
        input type: "datetime-local"
        input type: :email
        input type: :file
        input type: :hidden
        input type: :image
        input type: :month
        input type: :number
        input type: :password
        input type: :radio
        input type: :range
        input type: :reset
        input type: :search
        input type: :submit
        input type: :tel
        input type: :text
        input type: :time
        input type: :url
        input type: :week
      end
    end
  end

  describe "MyView#to_html" do
    it "should return the correct HTML" do
      view = MyView.new

      expected = <<-HTML.squish
      <form>
        <input type="button">
        <input type="checkbox">
        <input type="color">
        <input type="date">
        <input type="datetime-local">
        <input type="email">
        <input type="file">
        <input type="hidden">
        <input type="image">
        <input type="month">
        <input type="number">
        <input type="password">
        <input type="radio">
        <input type="range">
        <input type="reset">
        <input type="search">
        <input type="submit">
        <input type="tel">
        <input type="text">
        <input type="time">
        <input type="url">
        <input type="week">
      </form>
      HTML

      view.to_html.should eq(expected)
    end
  end
end
