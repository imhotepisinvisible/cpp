require 'tag_extend'
ActsAsTaggableOn.force_lowercase = true
ActsAsTaggableOn::Tag.send(:include, TagExtend)
