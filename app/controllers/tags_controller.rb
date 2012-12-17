class TagsController < ApplicationController
  respond_to :json

  def skills
    respond_with get_tags_for_contexts(["skills", "reject_skills"], params[:exclude_tags])
  end

  def interests
    respond_with get_tags_for_contexts(["interests", "reject_interests"], params[:exclude_tags])
  end

  def year_groups
    respond_with get_tags_for_contexts(["year_groups"], params[:exclude_tags])
  end

  def reject_skills
    respond_with get_tags_for_contexts(["skills","reject_skills"], params[:exclude_tags])
  end

  def reject_interests
    respond_with get_tags_for_contexts(["interests","reject_interests"], params[:exclude_tags])
  end

  def reject_year_groups
    respond_with get_tags_for_contexts(["year_groups","reject_year_groups"], params[:exclude_tags])
  end

  def validate
    tag = ActsAsTaggableOn::Tag.new
    tag.name = params[:tag]
    if tag.valid?
      head :no_content
    else
      respond_with tag.errors, status: :unprocessable_entity
    end
  end

  private

  def get_tags_for_contexts(contexts, excluded_tags)
    excluded_tags = [] if excluded_tags.blank?
    if current_user.type == "Student"
      excluded_tags += get_tags_for_user_for_contexts(current_user, contexts)
    end
    tags = contexts.map{|c| get_tags_for_contexts c }.flatten
    tags = tags - excluded_tags
  end

  def get_tags_for_user_for_contexts(user, contexts)
    contexts.map{|c| user.send c.to_sym }.flatten.map(&:name)
  end
end
