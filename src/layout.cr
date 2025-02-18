module ToHtml
  # Generic base layout
  class Layout
    def initialize(**args : **T) forall T
      {% for key in T.keys.map(&.id) %}
        {% if ivar = @type.instance_vars.find { |iv| iv.id == key } %}
          unless (%arg{key} = args[{{key.symbolize}}]).nil?
            @{{key}} = %arg{key}
          else
            {% unless ivar.type.nilable? || ivar.has_default_value? %}
              raise "{{key}} can not be nil"
            {% end %}
          end
        {% end %}
      {% end %}
    end

    def window_title
      nil
    end

    def viewport_meta?
      true
    end

    macro viewport_meta(bool)
      def viewport_meta?
        {{bool}}
      end
    end

    def head_children
      Tuple.new
    end

    macro append_to_head(*objs)
      def head_children
        {% if @type.methods.map(&.name).includes?("head_children".id) %}
          previous_def + Tuple.new({{objs.splat}})
        {% else %}
          super + Tuple.new({{objs.splat}})
        {% end %}
      end
    end

    def _body_attributes
      Tuple.new
    end

    macro body_attributes(*objs)
      def _body_attributes
        {% if @type.methods.map(&.name).includes?("_body_attributes".id) %}
          previous_def + Tuple.new({{objs.splat}})
        {% else %}
          super + Tuple.new({{objs.splat}})
        {% end %}
      end
    end

    ToHtml.instance_template do
      doctype "html"
      html do
        head do
          title { window_title }
          if viewport_meta?
            meta charset: "utf-8", name: "viewport", content: "width=device-width, initial-scale=1.0"
          end
          head_children.each do |head_child|
            head_child
          end
        end
        body(_body_attributes) do
          yield
        end
      end
    end
  end
end
