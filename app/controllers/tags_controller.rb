class TagsController < ApplicationController
  impressionist
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
    name = params[:tag].downcase
    # We find the tag with the given name, if it exists
    # then we know the list only has one object, so index[0]
    # since names are unique
    tag = ActsAsTaggableOn::Tag.where("name= ?", name)[0]
    if tag == nil
        tag = ActsAsTaggableOn::Tag.new
        tag.name = name
      if tag.valid?
        head :no_content
      else
        respond_with tag.errors, status: :unprocessable_entity
      end
    end
    head :no_content
  end

  private

  def get_tags_for_contexts(contexts, excluded_tags)
    excluded_tags = [] if excluded_tags.blank?
    if current_user.type == "Student"
      excluded_tags += get_tags_for_user_for_contexts(current_user, contexts)
    end
    tags = contexts.map{|c| get_tags_for_context c }.flatten
    tags = tags - excluded_tags
  end

  def get_tags_for_context(context)
    ActsAsTaggableOn::Tag.includes(:taggings)
    .where("taggings.context = '#{context}'")
    .select("DISTINCT tags.*")
    .map(&:name)
  end

  def get_tags_for_user_for_contexts(user, contexts)
    contexts.map{|c| user.send c.to_sym }.flatten.map(&:name)
  end
end
