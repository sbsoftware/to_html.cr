require "ecr"

module ToHtml
  module Benchmark
    class EcrTemplate
      def some_string
        "foo"
      end

      def names
        ["Peter", "Paul", "Mary"]
      end

      ECR.def_to_s("./benchmark/ecr_template.ecr")
    end
  end
end
