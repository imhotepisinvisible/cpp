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
      can [:read, :download_document, :set_rating], Company do |company|
        # Get departments for both and check they intersect
        company_deps = company.departments.map(&:id)
        student_deps = user.departments.map(&:id)
        !(company_deps | student_deps).empty?
      end
    when "CompanyAdministrator"
      can :manage, CompanyAdministrator, :id => user.id
      can :manage, Company, :id => user.company_id
      can [:read, :download_document], Student do |student|
        # Get departments for both and check they intersect
        company_deps = user.company.departments.map(&:id)
        student_deps = student.departments.map(&:id)
        !(company_deps | student_deps).empty?
      end
    when "DepartmentAdministrator"
      can :manage, DepartmentAdministrator, :id => user.id
      can :manage, Department, :id => user.department_id
      can :manage, Company do |company|
        company.departments.map(&:id).include? user.department_id
      end
      can :manage, Student do |student|
        student.departments.map(&:id).include? user.department_id
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
end
