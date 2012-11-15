class TagsController < ApplicationController
  respond_to :json

  def skills
    respond_with ActsAsTaggableOn::Tag.all
  end

  def interests
    respond_with ActsAsTaggableOn::Tag.all
  end

  def year_groups
    respond_with ActsAsTaggableOn::Tag.all
  end
end
