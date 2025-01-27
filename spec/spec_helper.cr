require "spec"
require "../src/to_html"

# TODO: Move that to some util shard or maybe that even exists already
class String
  def squish
    split(/\n\s*/).join
  end
end
