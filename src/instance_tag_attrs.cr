module ToHtml
  macro instance_tag_attrs(&blk)
    def to_html_attrs(tag, attr_hash)
      ToHtml.to_html_attrs_eval_exps {{blk}}
    end
  end

  macro class_tag_attrs(&blk)
    def self.to_html_attrs(tag, attr_hash)
      ToHtml.to_html_attrs_eval_exps {{blk}}
    end
  end

  # :nodoc:
  macro to_html_attrs_eval_exps(&blk)
    {% if blk.body.is_a?(Expressions) %}
      {% for exp in blk.body.expressions %}
        ToHtml.to_html_attrs_eval_exp({{exp}})
      {% end %}
    {% else %}
      ToHtml.to_html_attrs_eval_exp({{blk.body}})
    {% end %}
  end

  # :nodoc:
  macro to_html_attrs_eval_exp(exp)
    {% if exp.is_a?(Assign) %}
      attr_hash[{{exp.target.stringify.gsub(/_/, "-")}}] = {{exp.value}}
    {% elsif exp.is_a?(Call) && exp.block && !exp.block.body.is_a?(Nop) %}
      if tag == {{exp.name.stringify}}
        {% if exp.block.body.is_a?(Expressions) %}
          {% for tag_exp in exp.block.body.expressions %}
            ToHtml.to_html_attrs_eval_exp({{tag_exp}})
          {% end %}
        {% else %}
          ToHtml.to_html_attrs_eval_exp({{exp.block.body}})
        {% end %}
      end
    {% end %}
  end
end
