require "benchmark"
require "./to_html"
require "./ecr"
require "./blueprint"
require "./water"
require "./html_builder"
require "./markout"

to_html = ToHtml::Benchmark::ToHtmlTemplate.new
ecr = ToHtml::Benchmark::EcrTemplate.new
blueprint = ToHtml::Benchmark::BlueprintTemplate.new
raw_blueprint = ToHtml::Benchmark::RawBlueprintTemplate.new
water = ToHtml::Benchmark::WaterTemplate.new
html_builder = ToHtml::Benchmark::HtmlBuilderTemplate.new
markout = ToHtml::Benchmark::MarkoutTemplate.new

def normalize(input)
  input.gsub(/'/, "\"").split(/\n\s*/).join
end

to_html_output = normalize(to_html.to_html)

{
  "ecr" => normalize(ecr.to_s),
  "blueprint" => normalize(blueprint.to_html),
  "raw_blueprint" => normalize(raw_blueprint.to_html),
  "water" => normalize(water.to_html),
  "html_builder" => normalize(html_builder.to_s),
  "markout" => normalize(markout.to_s)
}.each do |name, output|
  if to_html_output != output
    puts to_html_output
    puts "#####"
    puts output
    raise "#{name} output does not match"
  end
end

Benchmark.ips do |x|
  x.report("ecr") { ToHtml::Benchmark::EcrTemplate.new.to_s }
  x.report("to_html") { ToHtml::Benchmark::ToHtmlTemplate.new.to_html }
  x.report("raw blueprint") { ToHtml::Benchmark::RawBlueprintTemplate.new.to_html }
  x.report("blueprint") { ToHtml::Benchmark::BlueprintTemplate.new.to_html }
  x.report("html_builder") { ToHtml::Benchmark::HtmlBuilderTemplate.new.to_s }
  x.report("water") { ToHtml::Benchmark::WaterTemplate.new.to_html }
  x.report("markout") { ToHtml::Benchmark::MarkoutTemplate.new.to_s }
end
