macro def_to_html_attrs(&blk)
  def to_html_attrs(tag, attr_hash)
    to_html_attrs_eval_exps {{blk}}
  end
end

macro self_to_html_attrs(&blk)
  def self.to_html_attrs(tag, attr_hash)
    to_html_attrs_eval_exps {{blk}}
  end
end

macro to_html_attrs_eval_exps(&blk)
  {% if blk.body.is_a?(Expressions) %}
    {% for exp in blk.body.expressions %}
      to_html_attrs_eval_exp({{exp}})
    {% end %}
  {% else %}
    to_html_attrs_eval_exp({{blk.body}})
  {% end %}
end

macro to_html_attrs_eval_exp(exp)
  {% if exp.is_a?(Assign) %}
    attr_hash[{{exp.target.stringify.gsub(/_/, "-")}}] = {{exp.value}}
  {% elsif exp.is_a?(Call) && exp.block && !exp.block.body.is_a?(Nop) %}
    if tag == {{exp.name.stringify}}
      {% if exp.block.body.is_a?(Expressions) %}
        {% for tag_exp in exp.block.body.expressions %}
          to_html_attrs_eval_exp({{tag_exp}})
        {% end %}
      {% else %}
        to_html_attrs_eval_exp({{exp.block.body}})
      {% end %}
    end
  {% end %}
end
