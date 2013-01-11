class TagsController < ApplicationController
  respond_to :json

  # Find all tags that have been declared as a skill or rejected skill
  # Excludes any excluded tags in params
  #
  # /tags/skills
  def skills
    respond_with get_tags_for_contexts(["skills", "reject_skills"], params[:exclude_tags])
  end

  # Find all tags that have been declared as a interest or rejected interest
  # Excludes any excluded tags in params
  #
  # /tags/interests
  def interests
    respond_with get_tags_for_contexts(["interests", "reject_interests"], params[:exclude_tags])
  end

  # Find all tags that have been declared as a year_group
  # Excludes any excluded tags in params
  #
  # /tags/skills
  def year_groups
    respond_with get_tags_for_contexts(["year_groups"], params[:exclude_tags])
  end

  # Find all tags that have been declared as a skill or rejected skill
  # Excludes any excluded tags in params
  #
  # /tags/reject_skills
  def reject_skills
    respond_with get_tags_for_contexts(["skills","reject_skills"], params[:exclude_tags])
  end

  # Find all tags that have been declared as a interest or a rejected interest
  # Excludes any excluded tags in params
  #
  # /tags/reject_interests
  def reject_interests
    respond_with get_tags_for_contexts(["interests","reject_interests"], params[:exclude_tags])
  end
  
  # Find all tags that have been declared as a year group or a rejected year group
  # Excludes any excluded tags in params
  #
  # /tags/reject_year_groups
  def reject_year_groups
    respond_with get_tags_for_contexts(["year_groups","reject_year_groups"], params[:exclude_tags])
  end

  # Validates tag specified in params

  # Find the tag with the given name, if it exists
  # then we know the list only has one object, so index[0] is fine since names
  # are unique.
  # 
  # /tags/validate/
  def validate
    name = params[:tag].downcase

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


  ######################## PRIVATE METHODS ############################
  private

  # Finds tag for context and removes any excluded tags
  def get_tags_for_contexts(contexts, excluded_tags)
    excluded_tags = [] if excluded_tags.blank?
    if current_user.type == "Student"
      excluded_tags += get_tags_for_user_for_contexts(current_user, contexts)
    end
    tags = contexts.map{|c| get_tags_for_context c }.flatten
    tags = tags - excluded_tags
  end

  # Finds all tags for context
  def get_tags_for_context(context)
    ActsAsTaggableOn::Tag.includes(:taggings)
    .where("taggings.context = '#{context}'")
    .select("DISTINCT tags.*")
    .map(&:name)
  end

  # Get tags for multiple contexts
  def get_tags_for_user_for_contexts(user, contexts)
    contexts.map{|c| user.send c.to_sym }.flatten.map(&:name)
  end
end
