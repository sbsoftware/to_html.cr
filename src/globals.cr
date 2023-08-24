require "./to_html"

macro instance_template(&blk)
  ToHtml.instance_template {{blk}}
end

macro class_template(&blk)
  ToHtml.class_template {{blk}}
end

macro instance_tag_attrs(&blk)
  ToHtml.instance_tag_attrs {{blk}}
end

macro class_tag_attrs(&blk)
  ToHtml.class_tag_attrs {{blk}}
end
