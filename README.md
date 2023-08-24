# `to_html`

`to_html` is the fastest HTML builder library for Crystal you can get (see [Benchmark](#benchmark)).

The main idea behind this project is to be able to output HTML without leaving the Crystal syntax, as most templates need to contain logic and thus most other templating engines implement their own way of expressing such logic. Why not just use the tools we already have?

Another important core concept is that what can be known at compile-time should not be calculated at runtime. That's why all of this functionality is provided via macros that do their best to prepare everything while compiling to be ready to *just render* when your program runs. Just like [ECR](https://crystal-lang.org/api/latest/ECR.html) (and almost as fast as it), only with a better interface ;-)

## Contents

- [Usage](#usage)
- [Examples](#examples)
- [Benchmark](#benchmark)

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
         end
       end
    end
  end
end
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

class MyView
  ToHtml.instance_template do
    h1 { "Hello World!" }
    p do
      "This is a template."
      br
      "Treat it well."
    end
  end
end

puts MyView.new.to_html
```

### Dynamic Instance Template

```crystal
require "to_html"

class MyView
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

puts MyView.new("Template!").to_html
```

### Class template

```crystal
require "to_html"

class MyView
  ToHtml.class_template do
    div do
      p { "This needs no instance" }
    end
  end
end

puts MyView.to_html
```

### Attributes

#### Named Arguments

You can add attributes to your tags via named arguments to the calls.

```crystal
require "to_html"

class MyView
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

puts MyView.new.to_html
```

#### Object Interface

Another way to add attributes is via objects that implement `#to_tag_attrs`. The easiest way to do so is via the `ToHtml.instance_tag_attrs`/`ToHtml.class_tag_attrs` macros.
This is still a bit experimental but the following example shows a few possible use cases, as well as the full potential of these macros.

```crystal
class MyView
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
puts MyView.new.to_html
```

### More

For more examples, the [specs](https://github.com/sbsoftware/to_html.cr/tree/main/spec) are quite expressive.

## Benchmark

Have a look into the `benchmark/` folder to find out how these numbers were determined. As this has only been done on one local machine, the absolute numbers are not meaningful. The ratios are the interesting part and the reason for this listing.

Execute `crystal run --release benchmark/benchmark.cr` to reproduce.

```
      ecr 875.25k (  1.14µs) (± 6.52%)  4.25kB/op          fastest
  to_html 538.74k (  1.86µs) (± 1.15%)  5.34kB/op     1.62× slower
    water  62.29k ( 16.05µs) (± 2.13%)  11.5kB/op    14.05× slower
blueprint 828.39  (  1.21ms) (±21.01%)  6.56MB/op  1056.58× slower
```

Compared shards taken from [awesome-crystal](https://github.com/veelenga/awesome-crystal#html-builders)
