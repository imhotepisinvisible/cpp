class TagsController < ApplicationController
  respond_to :json

  def skills
    respond_with get_available_tags_for_context("skills", params[:exclude_tags])
  end

  def interests
    respond_with get_available_tags_for_context("interests", params[:exclude_tags])
  end

  def year_groups
    respond_with get_available_tags_for_context("year_groups", params[:exclude_tags])
  end

  private

  def get_available_tags_for_context(context, excluded_tags)
    excluded_tags = [] if excluded_tags.blank?
    tags = get_tags_for_context context
    return tags - excluded_tags
  end

  def get_tags_for_context(context)
    ActsAsTaggableOn::Tag.includes(:taggings)
      .where("taggings.context = '#{context}'")
      .select("DISTINCT tags.*")
      .map(&:name)
  end
end
