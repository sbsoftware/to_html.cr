require "spec"
require "../src/instance_template"
require "../src/instance_tag_attrs"

# TODO: Move that to some util shard or maybe that even exists already
class String
  def squish
    split(/\n\s*/).join
  end
end
