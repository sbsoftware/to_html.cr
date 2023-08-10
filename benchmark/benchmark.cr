require "benchmark"
require "./to_html"
require "./ecr"
require "./blueprint"
require "./water"

to_html = ToHtml::Benchmark::ToHtmlTemplate.new
ecr = ToHtml::Benchmark::EcrTemplate.new
blueprint = ToHtml::Benchmark::BlueprintTemplate.new
water = ToHtml::Benchmark::WaterTemplate.new

def normalize(input)
  input.split(/\n\s*/).join
end

to_html_output = normalize(to_html.to_html)

{
  "ecr" => normalize(ecr.to_s),
  "blueprint" => normalize(blueprint.to_html),
  "water" => normalize(water.to_html)
}.each do |name, output|
  if to_html_output != output
    puts to_html_output
    puts "#####"
    puts output
    raise "#{name} output does not match"
  end
end

Benchmark.ips do |x|
  x.report("ecr") { ecr.to_s }
  x.report("to_html") { to_html.to_html }
  x.report("water") { water.to_html }
  x.report("blueprint") { blueprint.to_html }
end
