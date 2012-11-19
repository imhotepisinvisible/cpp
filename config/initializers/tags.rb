require 'tag_extend'
ActsAsTaggableOn::Tag.send(:include, TagExtend)
