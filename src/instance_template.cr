require "./tag_names"
require "./attribute_hash"

module ToHtml
  macro instance_template(&blk)
    def to_html(io, indent_level = 0)
      ToHtml.to_html_eval_exps(io, indent_level) {{blk}}
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

  macro class_template(&blk)
    def self.to_html(io, indent_level = 0)
      ToHtml.to_html_eval_exps(io, indent_level) {{blk}}
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

  # :nodoc:
  macro to_html_eval_exps(io, indent_level, &blk)
    {% if blk.body.is_a?(Expressions) %}
      {% for exp, index in blk.body.expressions %}
        ToHtml.to_html_eval_exp({{io}}, {{indent_level}}, {{!(index == blk.body.expressions.size - 1)}}) do
          {{exp}}
        end
      {% end %}
    {% else %}
      ToHtml.to_html_eval_exp({{io}}, {{indent_level}}, false) do
        {{blk.body}}
      end
    {% end %}
  end

  # :nodoc:
  macro to_html_eval_exp(io, indent_level, break_line = true, &blk)
    {% if blk.body.is_a?(Call) && blk.body.receiver.nil? && ToHtml::VOID_TAG_NAMES.includes?(blk.body.name.stringify) %}
      ToHtml.to_html_add_void_tag({{io}}, {{indent_level}}, {{break_line}}, {{blk.body}})
    {% elsif blk.body.is_a?(Call) && blk.body.receiver.nil? && ToHtml::TAG_NAMES.keys.includes?(blk.body.name.stringify) %}
      ToHtml.to_html_add_tag({{io}}, {{indent_level}}, {{break_line}}, {{blk.body}})
    {% elsif blk.body.is_a?(Call) && blk.body.receiver.nil? && blk.body.name.stringify == "doctype" %}
      {{io}} << "<!DOCTYPE {{blk.body.args.first.id}}>"
    {% elsif blk.body.is_a?(Call) && blk.body.receiver && blk.body.name.stringify == "each" %}
      {{blk.body.receiver}}.each_with_index do {% if !blk.body.block.args.empty? %} |{{blk.body.block.args.splat}}, %index| {% end %}
        ToHtml.to_html_eval_exps({{io}}, {{indent_level}}) do
          {{blk.body.block.body}}
        end
        {% if flag?(:to_html_pretty) %}
          {{io}} << "\n" unless %index == {{blk.body.receiver}}.size - 1
        {% end %}
      end
    {% elsif blk.body.is_a?(Call) && blk.body.receiver && blk.body.name.stringify == "to_html" && blk.body.block %}
      {{blk.body.receiver}}.to_html({{io}}, {{indent_level}}) do |%io, %indent_level|
        ToHtml.to_html_eval_exps(%io, %indent_level) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(Call) && blk.body.name.stringify == "super" && blk.body.block %}
      super do
        ToHtml.to_html_eval_exps({{io}}, {{indent_level}}) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(Call) && blk.body.name.stringify == "previous_def" && blk.body.block %}
      previous_def do
        ToHtml.to_html_eval_exps({{io}}, {{indent_level}}) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(If) %}
      if {{blk.body.cond}}
        {% if !blk.body.then.nil? %}
          ToHtml.to_html_eval_exps({{io}}, {{indent_level}}) do
            {{blk.body.then}}
          end
          {% if flag?(:to_html_pretty) && break_line %}
            {{io}} << "\n"
          {% end %}
        {% end %}
      {% if !blk.body.else.nil? %}
        else
          ToHtml.to_html_eval_exps({{io}}, {{indent_level}}) do
            {{blk.body.else}}
          end
          {% if flag?(:to_html_pretty) && break_line %}
            {{io}} << "\n"
          {% end %}
      {% end %}
      end
    {% elsif blk.body.is_a?(Assign) %}
      # Don't print this to the IO
      {{blk.body}}
    {% elsif blk.body.is_a?(Yield) %}
      yield {{io}}, {{indent_level}}
    {% elsif blk.body.is_a?(Nop) %}
      # do nothing
    {% else %}
      %var = {{blk.body}}
      if %var.responds_to?(:to_html)
        %var.to_html({{io}}, {{indent_level}})
      else
        {% if flag?(:to_html_pretty) %}
          {{io}} << "  " * {{indent_level}}
        {% end %}
        {{io}} << %var
      end
    {% end %}
  end

  # :nodoc:
  macro to_html_add_tag(io, indent_level, break_line, call)
    {% if flag?(:to_html_pretty) %}
      {{io}} << "  " * {{indent_level}}
    {% end %}
    {% if call.args.empty? && !call.named_args && call.block && call.block.body.is_a?(StringLiteral) %}
      {{io}} << {{"<" + ToHtml::TAG_NAMES[call.name.stringify] + ">" + call.block.body + "</" + ToHtml::TAG_NAMES[call.name.stringify] + ">"}}
    {% elsif call.args.empty? && call.named_args && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) } && call.block && call.block.body.is_a?(StringLiteral) %}
      {{io}} << {{"<" + ToHtml::TAG_NAMES[call.name.stringify] + " " + call.named_args.map { |a| "#{a.name}=#{a.value}" }.join(" ") + ">" + call.block.body + "</" + ToHtml::TAG_NAMES[call.name.stringify] + ">"}}
    {% else %}
      {% if call.named_args && call.args.empty? && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) } %}
        {{io}} << {{"<" + ToHtml::TAG_NAMES[call.name.stringify] + " " + call.named_args.map { |a| "#{a.name}=#{a.value}" } .join(" ") + ">"}}
      {% else %}
        %attr_hash = ToHtml::AttributeHash.new

        {% for arg in call.args %}
          {% if arg.is_a?(TupleLiteral) %}
            %attr_hash[{{arg}}.first] = {{arg}}.last
          {% else %}
            %arg = {{arg}}
            if %arg.is_a?(Array) || %arg.is_a?(Tuple)
              %arg.each do |item|
                item.to_html_attrs({{ToHtml::TAG_NAMES[call.name.stringify]}}, %attr_hash)
              end
            else
              %arg.to_html_attrs({{ToHtml::TAG_NAMES[call.name.stringify]}}, %attr_hash)
            end
          {% end %}
        {% end %}

        {% if call.named_args %}
          {% for named_arg in call.named_args %}
            %attr_hash[{{named_arg.name.stringify}}] = {{named_arg.value}}
          {% end %}
        {% end %}

        {{io}} << "<{{ToHtml::TAG_NAMES[call.name.stringify].id}}"
        {{io}} << " " unless %attr_hash.empty?
        {{io}} << %attr_hash
        {{io}} << ">"
      {% end %}
      {% if call.block %}
        {% if call.block.body.is_a?(StringLiteral) %}
          {{io}} << {{call.block.body}}
        {% else %}
          {% if flag?(:to_html_pretty) %}
            {{io}} << "\n"
          {% end %}
          ToHtml.to_html_eval_exps({{io}}, ({{indent_level}} + 1)) {{call.block}}
          {% if flag?(:to_html_pretty) %}
            {{io}} << "\n"
          {% end %}
          {% if flag?(:to_html_pretty) %}
            {{io}} << "  " * {{indent_level}}
          {% end %}
        {% end %}
      {% end %}
      {{io}} << "</{{ToHtml::TAG_NAMES[call.name.stringify].id}}>"
      {% if flag?(:to_html_pretty) && break_line %}
        {{io}} << "\n"
      {% end %}
    {% end %}
  end

  # :nodoc:
  macro to_html_add_void_tag(io, indent_level, break_line, call)
    {% if flag?(:to_html_pretty) %}
      {{io}} << "  " * {{indent_level}}
    {% end %}
    {% if call.args.empty? && !call.named_args %}
      {{io}} << "<{{call.name}}>"
    {% elsif call.args.empty? && call.named_args && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) } %}
      {{io}} << "<{{call.name}} " + {{ call.named_args.map { |a| "#{a.name}=#{a.value}" }.join(" ") }} + ">"
    {% else %}
      %attr_hash = ToHtml::AttributeHash.new

      {% for arg in call.args %}
        {% if arg.is_a?(TupleLiteral) %}
          %attr_hash[{{arg}}.first] = {{arg}}.last
        {% else %}
          %arg = {{arg}}
          if %arg.is_a?(Array)
            %arg.each do |item|
              item.to_html_attrs({{call.name.stringify}}, %attr_hash)
            end
          else
            %arg.to_html_attrs({{call.name.stringify}}, %attr_hash)
          end
        {% end %}
      {% end %}

      {% if call.named_args %}
        {% for named_arg in call.named_args %}
          %attr_hash[{{named_arg.name.stringify}}] = {{named_arg.value}}
        {% end %}
      {% end %}

      {{io}} << "<{{call.name}}"
      {{io}} << " " unless %attr_hash.empty?
      {{io}} << %attr_hash
      {{io}} << ">"
    {% end %}
    {% if flag?(:to_html_pretty) && break_line %}
      {{io}} << "\n"
    {% end %}
  end
end
