# `to_html`

`to_html` is the fastest HTML builder library for Crystal you can get (see [Benchmark](#benchmark)).

![CI badge](https://github.com/sbsoftware/to_html.cr/actions/workflows/crystal.yml/badge.svg?event=push)
![Weekly CI badge](https://github.com/sbsoftware/to_html.cr/actions/workflows/weekly_crystal.yml/badge.svg)

The main idea behind this project is to be able to output HTML without leaving the Crystal syntax, as most templates need to contain logic and thus most other templating engines implement their own way of expressing such logic. Why not just use the tools we already have?

Another important core concept is that what can be known at compile-time should not be calculated at runtime. That's why all of this functionality is provided via macros that do their best to prepare everything while compiling to be ready to *just render* when your program runs. Just like [ECR](https://crystal-lang.org/api/latest/ECR.html) (and almost as fast as it), only with a better interface ;-)

## Contents

- [Usage](#usage)
- [Examples](#examples)
- [Benchmark](#benchmark)
- [Contributing](#contributing)

## Usage

*shard.yml*
```crystal
dependencies:
  to_html:
    github: sbsoftware/to_html.cr
```

*somewhere in your code*
```crystal
require "to_html"
```

*in any class/module*
```crystal
class MyView
  # defines #to_html(io : IO) and #to_html
  ToHtml.instance_template do
    # use any HTML5 tag name as a method call with a block
    html lang: "en" do
       head do
         title { "My View" }
       end
       body do
         main do
           p { "Tada!" }
           # special case: `select` is a reserved keyword in crystal; need to use `select_tag` instead
           select_tag do
             option(value: "one") { "One" }
             option(value: "two", selected: true) { "Two" }
           end
         end
       end
    end
  end
end
```

### Element Concatenation

Just write your tag name calls and as many string literals as you want below each other - they will all be concatenated. You can also use control logic like `if`s and `#each`.

```crystal
require "to_html"

class MyLongView
  getter show_author : Bool
  getter random_lines : Array(String)

  def initialize(@show_author, @random_lines); end

  ToHtml.instance_template do
    div do
      p do
        "In the realm of code, so vast and wide,"
        br
        "An HTML div began its thrilling ride."
        br
        "With attributes unique, it came alive,"
        br
        "To journey through the web, it would strive."
      end

      if show_author
        div class: "author" do
          i { "ChatGPT" }
        end
      end

      p do
        random_lines.each do |random_line|
          strong { random_line }
          br
        end
      end
    end
  end
end

puts MyLongView.new(true, ["Test", "Blah", "Foo"]).to_html
```

### Global Macros

If you're sure you won't get any name clashes (or you don't care), you can `require "to_html/globals"` to get rid of the module name before calling the template macros.

```crystal
require "to_html/globals"

class MyView
  instance_template do
    div do
      strong { "More concise!" }
    end
  end
end
```

## Examples

### Static Instance Template

```crystal
require "to_html"

class StaticInstanceView
  ToHtml.instance_template do
    h1 { "Hello World!" }
    p do
      "This is a template."
      br
      "Treat it well."
    end
  end
end

puts StaticInstanceView.new.to_html
```

### Dynamic Instance Template

```crystal
require "to_html"

class DynamicInstanceView
  getter heading : String

  def initialize(@heading); end

  ToHtml.instance_template do
    h1 { heading }
    p do
      "This is "
      i { "another" }
      " template."
    end
  end
end

puts DynamicInstanceView.new("Template!").to_html
```

### Class template

```crystal
require "to_html"

class ClassView
  ToHtml.class_template do
    div do
      p { "This needs no instance" }
    end
  end
end

puts ClassView.to_html
```

### Attributes

#### Named Arguments

You can add attributes to your tags via named arguments to the calls.

```crystal
require "to_html"

class NamedArgumentsView
  ToHtml.instance_template do
    div class: "my-div" do
      form action: "https://www.example.com", method: "POST" do
        input type: "submit", name: "submit", value: "Submit!"
        a href: "/index" do
          "Cancel"
        end
      end
    end
  end
end

puts NamedArgumentsView.new.to_html
```

#### Named Arguments with Symbols

You can provide your attribute values as String or as Symbol. The latter will in some cases be subject to a typecheck against an Enum that contains values officially supported by the standard.

As it is still your Symbol that is eventually used as the attribute value, this unfortunately doesn't work with keywords that contain a hyphen. You have to fall back to use a String if you want to use one of those.

[The list of Enums](src/attr_enums) to check attribute values against is still small and will only grow over time. Feel free to contribute by opening a PR adding more.

```crystal
require "to_html"

class SymbolNamedArgumentsView
  ToHtml.instance_template do
    form method: :get do
      # this will compile
      input type: :text
      # this won't
      input type: :foo
      # but this will
      input type: "foo"

      # this is not valid crystal
      input type: :datetime-local
      # this will lead to a wrong attribute value and is therefore not part of the enum
      input type: :datetime_local
      # you need to do it this way
      input type: "datetime-local"
    end
  end
end

puts SymbolNamedArgumentsView.new.to_html
```

#### Object Interface

Another way to add attributes is via objects that implement `#to_html_attrs`. The easiest way to do so is via the `ToHtml.instance_tag_attrs`/`ToHtml.class_tag_attrs` macros.
This is still a bit experimental but the following example shows a few possible use cases, as well as the full potential of these macros.

```crystal
require "to_html"

class ObjectInterfaceView
  ToHtml.instance_template do
    div MyObject do
      form MyResource do
        input type: "submit", name: "submit", value: "Submit"
      end
      a MyResource do
        MyResource.name
      end
    end
  end
end

class MyObject
  ToHtml.class_tag_attrs do
    data_controller = "my-object"
  end
end

class MyResource
  def self.path
    "/my_resource"
  end

  ToHtml.class_tag_attrs do
    form do
      action = path
    end
    a do
      href = path
    end
  end
end

# <div data-controller="my-object">
#   <form action="/my_resource">
#     <input type="submit" name="submit" value="Submit">
#   </form>
#   <a href="/my_resource">MyResource</a>
# </div>
puts ObjectInterfaceView.new.to_html
```

### More

For more examples, the [specs](https://github.com/sbsoftware/to_html.cr/tree/main/spec) are quite expressive.

## Benchmark

Have a look into the `benchmark/` folder to find out how these numbers were determined. As this has only been done on one local machine, the absolute numbers are not meaningful. The ratios are the interesting part and the reason for this listing.

Execute `crystal run --release benchmark/benchmark.cr` to reproduce.

```
         ecr   1.55M (645.91ns) (± 5.16%)  4.27kB/op        fastest
     to_html 902.82k (  1.11µs) (± 8.18%)  5.52kB/op   1.71× slower
   blueprint 170.78k (  5.86µs) (± 8.85%)   9.8kB/op   9.07× slower
html_builder  62.44k ( 16.01µs) (± 3.41%)  10.4kB/op  24.79× slower
       water  61.90k ( 16.16µs) (± 1.18%)  11.2kB/op  25.01× slower
     markout  44.77k ( 22.34µs) (± 1.72%)  15.6kB/op  34.58× slower
```

Compared shards taken from [awesome-crystal](https://github.com/veelenga/awesome-crystal#html-builders)

## Contributing

1. Fork this repository
2. Read the [Contribution Guidelines](CONTRIBUTING.md)
3. Create a branch with your desired changes
4. Create a pull request
