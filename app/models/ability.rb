class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    case user.type
    when nil
      can :create, Student
    when "Student"
      can :manage, Student, :id => user.id
      can [:read, :download_document], Company do |company|
        # Get departments for both and check they intersect
        company_departments = user.company.departments.map(&:id)
        student_departments = user.departments.map(&:id)
        return intersect?(company_departments, student_departments)
      end
    when "CompanyAdministrator"
      can :manage, Company, :id => user.company_id
      can [:read, :download_document], Student do |student|
        # Get departments for both and check they intersect
        company_departments = user.company.departments.map(&:id)
        student_departments = student.departments.map(&:id)
        return intersect?(company_departments, student_departments)
      end
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def intersect?(l1, l2)
    !(l1 | l2).empty?
  end
end
