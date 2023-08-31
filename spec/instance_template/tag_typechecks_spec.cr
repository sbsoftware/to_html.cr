require "../spec_helper"

module ToHtml::TagTypechecksSpec
  {% for tag_name in ToHtml::TAG_NAMES %}
    describe "TagTypechecks.{{tag_name.id}}_typecheck" do
      it "should be callable without arguments" do
        TagTypechecks.{{tag_name.id}}_typecheck
      end
    end
  {% end %}
end
