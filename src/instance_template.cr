require "./tag_names"
require "./tag_typechecks"
require "./attribute_hash"

module ToHtml
  extend TagTypechecks

  macro instance_template(&blk)
    def to_html(io)
      ToHtml.to_html_eval_exps(io) {{blk}}
    end

    def to_html
      String.build do |io|
        to_html(io)
      end
    end

    def to_html
      String.build do |io|
        to_html(io) do |inner_io|
          yield inner_io
        end
      end
    end
  end

  macro class_template(&blk)
    def self.to_html(io)
      ToHtml.to_html_eval_exps(io) {{blk}}
    end

    def self.to_html
      String.build do |io|
        to_html(io)
      end
    end

    def self.to_html
      String.build do |io|
        to_html(io) do |inner_io|
          yield inner_io
        end
      end
    end
  end

  macro inline_template(name, &blk)
    def {{name.id}}({{blk.args.splat}})
      ->(io : IO) do
        ToHtml.to_html_eval_exps(io) {{blk}}
        nil
      end
    end
  end

  macro class_inline_template(name, &blk)
    def self.{{name.id}}({{blk.args.splat}})
      ->(io : IO) do
        ToHtml.to_html_eval_exps(io) {{blk}}
        nil
      end
    end
  end

  # :nodoc:
  macro to_html_eval_exps(io, &blk)
    {% if blk.body.is_a?(Expressions) %}
      {% for exp in blk.body.expressions %}
        ToHtml.to_html_eval_exp({{io}}) do
          {{exp}}
        end
      {% end %}
    {% else %}
      ToHtml.to_html_eval_exp({{io}}) do
        {{blk.body}}
      end
    {% end %}
  end

  # :nodoc:
  macro to_html_eval_exp(io, &blk)
    {% if blk.body.is_a?(Call) && blk.body.receiver.nil? && ToHtml::VOID_TAG_NAMES.includes?(blk.body.name.stringify) %}
      ToHtml.to_html_add_void_tag({{io}}, {{blk.body}})
    {% elsif blk.body.is_a?(Call) && blk.body.receiver.nil? && ToHtml::TAG_NAMES.keys.includes?(blk.body.name.stringify) %}
      ToHtml.to_html_add_tag({{io}}, {{blk.body}})
    {% elsif blk.body.is_a?(Call) && blk.body.receiver.nil? && blk.body.name.stringify == "doctype" %}
      {{io}} << "<!DOCTYPE {{blk.body.args.first.id}}>"
    {% elsif blk.body.is_a?(Call) && blk.body.receiver && blk.body.name.stringify == "each" %}
      {{blk.body.receiver}}.each do {% if !blk.body.block.args.empty? %} |{{blk.body.block.args.splat}}| {% end %}
        ToHtml.to_html_eval_exps({{io}}) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(Call) && blk.body.receiver && blk.body.name.stringify == "to_html" && blk.body.block %}
      {{blk.body.receiver}}.to_html({{io}}) do |%io|
        ToHtml.to_html_eval_exps(%io) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(Call) && blk.body.name.stringify == "super" && blk.body.block %}
      super do
        ToHtml.to_html_eval_exps({{io}}) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(Call) && blk.body.name.stringify == "previous_def" && blk.body.block %}
      previous_def do
        ToHtml.to_html_eval_exps({{io}}) do
          {{blk.body.block.body}}
        end
      end
    {% elsif blk.body.is_a?(If) %}
      if {{blk.body.cond}}
        {% if !blk.body.then.nil? %}
          ToHtml.to_html_eval_exps({{io}}) do
            {{blk.body.then}}
          end
        {% end %}
      {% if !blk.body.else.nil? %}
        else
          ToHtml.to_html_eval_exps({{io}}) do
            {{blk.body.else}}
          end
      {% end %}
      end
    {% elsif blk.body.is_a?(MacroIf) %}
      \{% if {{blk.body.cond}} %}
        ToHtml.to_html_eval_exps({{io}}) do
          {{blk.body.then}}
        end
      \{% else %}
        ToHtml.to_html_eval_exps({{io}}) do
          {{blk.body.else}}
        end
      \{% end %}
    {% elsif blk.body.is_a?(MacroFor) %}
      \{% for {{blk.body.vars.splat}} in {{blk.body.exp}} %}
        ToHtml.to_html_eval_exps({{io}}) do
          {{blk.body.body.expressions.join("").id}}
        end
      \{% end %}
    {% elsif blk.body.is_a?(MacroExpression) || blk.body.is_a?(MacroLiteral) %}
      {{blk.body}}
    {% elsif blk.body.is_a?(Assign) %}
      # Don't print this to the IO
      {{blk.body}}
    {% elsif blk.body.is_a?(Yield) %}
      yield {{io}}
    {% elsif blk.body.is_a?(Nop) %}
      # do nothing
    {% else %}
      %var = {{blk.body}}
      if %var.is_a?(Proc(IO, Nil))
        %var.call({{io}})
      elsif %var.responds_to?(:to_html)
        %var.to_html({{io}})
      else
        {{io}} << %var
      end
    {% end %}
  end

  # :nodoc:
  macro to_html_add_tag(io, call)
    {% if call.args.empty? && !call.named_args && call.block && call.block.body.is_a?(StringLiteral) %}
      {{io}} << {{"<" + ToHtml::TAG_NAMES[call.name.stringify] + ">" + call.block.body + "</" + ToHtml::TAG_NAMES[call.name.stringify] + ">"}}
    {% elsif call.args.empty? && call.named_args && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) } && call.block && call.block.body.is_a?(StringLiteral) %}
      {{io}} << {{"<" + ToHtml::TAG_NAMES[call.name.stringify] + " " + call.named_args.map { |a| "#{a.name}=#{a.value.id.stringify}" }.join(" ") + ">" + call.block.body + "</" + ToHtml::TAG_NAMES[call.name.stringify] + ">"}}
    {% elsif call.args.empty? && call.named_args && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) || arg.value.is_a?(SymbolLiteral) } && call.block && call.block.body.is_a?(StringLiteral) %}
      {% typecheck = ToHtml::TagTypechecks.methods.find { |method| method.name == "#{call.name}_typecheck" } %}
      {% attr_parts = [] of ASTNode %}
      {% for named_arg in call.named_args %}
        {% if named_arg.value.is_a?(StringLiteral) %}
          {% attr_parts << "#{named_arg.name}=#{named_arg.value.id.stringify}" %}
        {% else %}
          {% symbol_value = named_arg.value.id.stringify %}
          {% enum_const = nil %}
          {% if typecheck %}
            {% arg_def = typecheck.args.find { |arg| arg.name == named_arg.name } %}
            {% if arg_def && arg_def.restriction %}
              {% match = arg_def.restriction.stringify.match(/AttrEnums::([A-Za-z0-9_]+)/) %}
              {% if match %}
                {% enum_name = match[1].id %}
                {% enum_member = symbol_value.gsub(/-/, "_").camelcase.id %}
                {% enum_const = "AttrEnums::#{enum_name}::#{enum_member}".id %}
              {% end %}
            {% end %}
          {% end %}
          {% if enum_const %}
            {% attr_parts << ("\"#{named_arg.name}=\\\"\" + #{enum_const}.to_s + \"\\\"\"").id %}
          {% else %}
            {% attr_parts << ("\"#{named_arg.name}=\\\"\" + #{symbol_value} + \"\\\"\"").id %}
          {% end %}
        {% end %}
      {% end %}
      {% attr_expr = attr_parts.first %}
      {% for part in attr_parts[1..] %}
        {% attr_expr = "#{attr_expr} + \" \" + #{part}".id %}
      {% end %}
      {% tag_name = ToHtml::TAG_NAMES[call.name.stringify] %}
      {{io}} << ("<" + {{tag_name}} + " " + {{attr_expr}} + ">" + {{call.block.body}} + "</" + {{tag_name}} + ">")
    {% else %}
      {% if call.named_args && call.args.empty? && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) } %}
        {{io}} << {{"<" + ToHtml::TAG_NAMES[call.name.stringify] + " " + call.named_args.map { |a| "#{a.name}=#{a.value.id.stringify}" }.join(" ") + ">"}}
      {% elsif call.named_args && call.args.empty? && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) || arg.value.is_a?(SymbolLiteral) } %}
        {% typecheck = ToHtml::TagTypechecks.methods.find { |method| method.name == "#{call.name}_typecheck" } %}
        {% attr_parts = [] of ASTNode %}
        {% for named_arg in call.named_args %}
          {% if named_arg.value.is_a?(StringLiteral) %}
            {% attr_parts << "#{named_arg.name}=#{named_arg.value.id.stringify}" %}
          {% else %}
            {% symbol_value = named_arg.value.id.stringify %}
            {% enum_const = nil %}
            {% if typecheck %}
              {% arg_def = typecheck.args.find { |arg| arg.name == named_arg.name } %}
              {% if arg_def && arg_def.restriction %}
                {% match = arg_def.restriction.stringify.match(/AttrEnums::([A-Za-z0-9_]+)/) %}
                {% if match %}
                  {% enum_name = match[1].id %}
                  {% enum_member = symbol_value.gsub(/-/, "_").camelcase.id %}
                  {% enum_const = "AttrEnums::#{enum_name}::#{enum_member}".id %}
                {% end %}
              {% end %}
            {% end %}
            {% if enum_const %}
              {% attr_parts << ("\"#{named_arg.name}=\\\"\" + #{enum_const}.to_s + \"\\\"\"").id %}
            {% else %}
              {% attr_parts << ("\"#{named_arg.name}=\\\"\" + #{symbol_value} + \"\\\"\"").id %}
            {% end %}
          {% end %}
        {% end %}
        {% attr_expr = attr_parts.first %}
        {% for part in attr_parts[1..] %}
          {% attr_expr = "#{attr_expr} + \" \" + #{part}".id %}
        {% end %}
        {% tag_name = ToHtml::TAG_NAMES[call.name.stringify] %}
        {{io}} << ("<" + {{tag_name}} + " " + {{attr_expr}} + ">")
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
          %named_args = ToHtml.{{ "#{call.name}_typecheck(#{call.named_args.splat})".id }}
          {% for named_arg in call.named_args %}
            %attr_hash[{{named_arg.name.stringify}}] = %named_args[{{named_arg.name.stringify}}]
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
          ToHtml.to_html_eval_exps({{io}}) {{call.block}}
        {% end %}
      {% end %}
      {{io}} << "</{{ToHtml::TAG_NAMES[call.name.stringify].id}}>"
    {% end %}
  end

  # :nodoc:
  macro to_html_add_void_tag(io, call)
    {% if call.args.empty? && !call.named_args %}
      {{io}} << "<{{call.name}}>"
    {% elsif call.args.empty? && call.named_args && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) } %}
      {{io}} << "<{{call.name}} " + {{ call.named_args.map { |a| "#{a.name}=#{a.value.id.stringify}" }.join(" ") }} + ">"
    {% elsif call.args.empty? && call.named_args && call.named_args.all? { |arg| arg.value.is_a?(StringLiteral) || arg.value.is_a?(SymbolLiteral) } %}
      {% typecheck = ToHtml::TagTypechecks.methods.find { |method| method.name == "#{call.name}_typecheck" } %}
      {% attr_parts = [] of ASTNode %}
      {% for named_arg in call.named_args %}
        {% if named_arg.value.is_a?(StringLiteral) %}
          {% attr_parts << "#{named_arg.name}=#{named_arg.value.id.stringify}" %}
        {% else %}
          {% symbol_value = named_arg.value.id.stringify %}
          {% enum_const = nil %}
          {% if typecheck %}
            {% arg_def = typecheck.args.find { |arg| arg.name == named_arg.name } %}
            {% if arg_def && arg_def.restriction %}
              {% match = arg_def.restriction.stringify.match(/AttrEnums::([A-Za-z0-9_]+)/) %}
              {% if match %}
                {% enum_name = match[1].id %}
                {% enum_member = symbol_value.gsub(/-/, "_").camelcase.id %}
                {% enum_const = "AttrEnums::#{enum_name}::#{enum_member}".id %}
              {% end %}
            {% end %}
          {% end %}
          {% if enum_const %}
            {% attr_parts << ("\"#{named_arg.name}=\\\"\" + #{enum_const}.to_s + \"\\\"\"").id %}
          {% else %}
            {% attr_parts << ("\"#{named_arg.name}=\\\"\" + #{symbol_value} + \"\\\"\"").id %}
          {% end %}
        {% end %}
      {% end %}
      {% attr_expr = attr_parts.first %}
      {% for part in attr_parts[1..] %}
        {% attr_expr = "#{attr_expr} + \" \" + #{part}".id %}
      {% end %}
      {% tag_name = call.name.stringify %}
      {{io}} << ("<" + {{tag_name}} + " " + {{attr_expr}} + ">")
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
        %named_args = ToHtml.{{ "#{call.name}_typecheck(#{call.named_args.splat})".id }}
        {% for named_arg in call.named_args %}
          %attr_hash[{{named_arg.name.stringify}}] = %named_args[{{named_arg.name.stringify}}]
        {% end %}
      {% end %}

      {{io}} << "<{{call.name}}"
      {{io}} << " " unless %attr_hash.empty?
      {{io}} << %attr_hash
      {{io}} << ">"
    {% end %}
  end
end
