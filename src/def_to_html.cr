require "./attribute_hash"

TAG_NAMES = %w[html head title body p ul ol li div strong i span h1 h2 h3 h4 h5 h6]

macro def_to_html(&blk)
  def to_html(io, indent_level = 0)
    to_html_eval_exps(io, indent_level) {{blk}}
  end

  def to_html
    String.build do |io|
      to_html(io)
    end
  end

  def to_html
    String.build do |io|
      to_html(io) do |inner_io, indent_level|
        yield inner_io, indent_level
      end
    end
  end
end

macro self_to_html(&blk)
  def self.to_html(io, indent_level = 0)
    to_html_eval_exps(io, indent_level) {{blk}}
  end

  def self.to_html
    String.build do |io|
      to_html(io)
    end
  end

  def self.to_html
    String.build do |io|
      to_html(io) do |inner_io, indent_level|
        yield inner_io, indent_level
      end
    end
  end
end

macro to_html_eval_exps(io, indent_level, &blk)
  {% if blk.body.is_a?(Expressions) %}
    {% for exp, index in blk.body.expressions %}
      to_html_eval_exp({{io}}, {{indent_level}}, {{!(index == blk.body.expressions.size - 1)}}) do
        {{exp}}
      end
    {% end %}
  {% else %}
    to_html_eval_exp({{io}}, {{indent_level}}, false) do
      {{blk.body}}
    end
  {% end %}
end

macro to_html_eval_exp(io, indent_level, break_line = true, &blk)
  {% if blk.body.is_a?(Call) && TAG_NAMES.includes?(blk.body.name.stringify) %}
    to_html_add_tag({{io}}, {{indent_level}}, {{break_line}}, {{blk.body}})
  {% elsif blk.body.is_a?(Call) && blk.body.receiver && blk.body.name.stringify == "each" %}
    {{blk.body.receiver}}.each_with_index do {% if !blk.body.block.args.empty? %} |{{blk.body.block.args.splat}}, %index| {% end %}
      to_html_eval_exps({{io}}, {{indent_level}}) do
        {{blk.body.block.body}}
      end
      {{io}} << "\n" unless %index == {{blk.body.receiver}}.size - 1
    end
  {% elsif blk.body.is_a?(If) %}
    if {{blk.body.cond}}
      {% if blk.body.then %}
        to_html_eval_exps({{io}}, {{indent_level}}) do
          {{blk.body.then}}
        end
        {% if break_line %}
          {{io}} << "\n"
        {% end %}
      {% end %}
    {% if blk.body.else %}
      else
        to_html_eval_exps({{io}}, {{indent_level}}) do
          {{blk.body.else}}
        end
        {% if break_line %}
          {{io}} << "\n"
        {% end %}
    {% end %}
    end
  {% elsif blk.body.is_a?(Yield) %}
    yield {{io}}, {{indent_level}}
  {% elsif blk.body.is_a?(Nop) %}
    # do nothing
  {% else %}
    %var = {{blk.body}}
    if %var.responds_to?(:to_html)
      %var.to_html({{io}}, {{indent_level}})
    else
      {{io}} << "  " * {{indent_level}}
      {{io}} << %var
    end
  {% end %}
end

macro to_html_add_tag(io, indent_level, break_line, call)
  {{io}} << "  " * {{indent_level}}
  {{io}} << "<{{call.name}}"
  {% if !call.args.empty? %}
    %attr_hash = ToHtml::AttributeHash.new
    {% for arg in call.args %}
      {% if arg.is_a?(TupleLiteral) %}
        %attr_hash[{{arg}}.first] = {{arg}}.last
      {% else %}
        {{arg}}.to_html_attrs({{call.name.stringify}}, %attr_hash)
      {% end %}
    {% end %}
    {{io}} << " "
    {{io}} << %attr_hash
  {% end %}
  {{io}} << ">"
  {% if call.block %}
    {% if call.block.body.is_a?(StringLiteral) %}
      {{io}} << {{call.block.body}}
    {% else %}
      {{io}} << "\n"
      to_html_eval_exps({{io}}, ({{indent_level}} + 1)) {{call.block}}
      {{io}} << "\n"
      {{io}} << "  " * {{indent_level}}
    {% end %}
  {% end %}
  {{io}} << "</{{call.name}}>"
  {% if break_line %}
    {{io}} << "\n"
  {% end %}
end
