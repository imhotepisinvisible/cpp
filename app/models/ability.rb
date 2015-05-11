class Ability
  include CanCan::Ability

  # Define abilities for the passed in user here.
  # Uses cases for different user types
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
  #
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    case user.type
    when nil
      can :create, Student
      can :request_approval, Student
      can :read, Department
    when "Student"
      can :manage, Student, :id => user.id
      cannot :index, Student
      can [:read, :register, :unregister, :attending_students], Event
      can :read, Placement
      can [:read, :download_document, :set_rating], Company
      can :read, Course
    when "CompanyAdministrator"
      can :manage, Event, :company_id => user.company_id
      can :manage, Placement, :company_id => user.company_id
      can :manage, TaggedEmail, :company_id => user.company_id
      can :manage, EventEmail, :company_id => user.company_id
      can :manage, DirectEmail, :company_id => user.company_id
      can :manage, Email, :company_id => user.company_id
      can :manage, Company, :id => user.company_id
      can :manage, CompanyAdministrator, :id => user.id
      can :apply, Department
      can :read, Course
      can :index, Student
      # Only allow companies that have been approved to see students.
      if user.company.reg_status == 3
        can :export_cvs, Student
        can :show, Student
        can :download_document, Student
      end
    when "DepartmentAdministrator"
      can :manage, Course
      can :manage, DepartmentAdministrator, :id => user.id
      can :create, CompanyAdministrator
      can :manage, CompanyAdministrator
      can :manage, Department
      #can :manage, Email do |email|
      #  email.company.all_departments.map(&:id).include? user.department_id
      #end
      can :manage, Email
      can :create, Company
      can :manage, Company
      can :create, Event
      can :manage, Event
      can :create, Placement
      can :manage, Placement
      can :create, Student
      can :manage, Student
      can :manage, Resque
    end

    unless user.type.nil?
      can :stat_show, :all
    end
  end

end
