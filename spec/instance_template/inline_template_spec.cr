require "../spec_helper"

module ToHtml::InstanceTemplate::InlineTemplateSpec
  class View
    ToHtml.inline_template :inline_fragment do
      h1 { "Hello" }
    end

    ToHtml.instance_template do
      div do
        inline_fragment
      end
    end
  end

  class VariableView
    getter name : String

    def initialize(@name)
    end

    ToHtml.inline_template :greeting do
      p { "Hello #{name}" }
    end

    ToHtml.instance_template do
      div do
        greeting
      end
    end
  end

  class ArgumentView
    ToHtml.inline_template :greeting do |name|
      p { "Hi #{name}" }
    end

    ToHtml.instance_template do
      div do
        greeting("Ada")
      end
    end
  end

  class ClassView
    ToHtml.class_inline_template :title_fragment do |title|
      h2 { title }
    end

    ToHtml.class_template do
      section do
        title_fragment("Hello")
      end
    end
  end

  describe "View#to_html with inline template" do
    it "renders the inline template proc" do
      expected = <<-HTML
      <div>
        <h1>Hello</h1>
      </div>
      HTML

      View.new.to_html.should eq(expected.squish)
    end
  end

  describe "inline template proc access to instance variables" do
    it "renders when called from the instance template" do
      expected = <<-HTML
      <div>
        <p>Hello Ada</p>
      </div>
      HTML

      VariableView.new("Ada").to_html.should eq(expected.squish)
    end
  end

  describe "inline template arguments" do
    it "renders when called from the instance template" do
      expected = <<-HTML
      <div>
        <p>Hi Ada</p>
      </div>
      HTML

      ArgumentView.new.to_html.should eq(expected.squish)
    end
  end

  describe "class inline templates" do
    it "render when called from the class template" do
      expected = <<-HTML
      <section>
        <h2>Hello</h2>
      </section>
      HTML

      ClassView.to_html.should eq(expected.squish)
    end
  end
end
