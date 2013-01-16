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
      can :create, Company
      can :read, Department
    when "Student"
      can :manage, Student, :id => user.id
      can [:read, :register, :unregister], Event do |event|
        user_depts = user.departments.map(&:id)
        event_depts = event.departments.map(&:id)
        !(user_depts & event_depts).empty?
      end
      can :read, Placement do |placement|
        user_depts = user.departments.map(&:id)
        placement_depts = placement.company.departments.map(&:id)
        !(user_depts & placement_depts).empty?
      end
      can [:read, :download_document, :set_rating], Company do |company|
        # Get departments for both and check they intersect
        company_deps = company.departments.map(&:id)
        student_deps = user.departments.map(&:id)
        !(company_deps & student_deps).empty?
      end
    when "CompanyAdministrator"
      can :manage, CompanyAdministrator, :id => user.id
      can :manage, Company, :id => user.company_id
      can [:read, :download_document], Student do |student|
        # Only departments which are student approved can view students
        company_deps = user.company.department_registrations.where(:status => 3)
                        .collect{|d| d.department}.map(&:id)
        student_deps = student.departments.map(&:id)
        !(company_deps & student_deps).empty?
      end
      can :manage, Event, :company_id => user.company_id
      can :create, Event
      can :manage, Placement, :company_id => user.company_id
      can :create, Placement
      can :apply, Department
      can :manage, TaggedEmail, :company_id => user.company_id
      can :manage, EventEmail, :company_id => user.company_id
      can :manage, DirectEmail, :company_id => user.company_id
    when "DepartmentAdministrator"
      can :manage, DepartmentAdministrator, :id => user.id
      can [:manage, :change_status], Department, :id => user.department_id

      can [:manage, :pending, :approve, :reject], Email do |email|
        email.company.all_departments.map(&:id).include? user.department_id
      end

      can [:read, :update, :view_stats_all, :view_stats, :top_5, 
           :download_document, :pending, :approve, :reject], Company do |company|
        company.all_departments.map(&:id).include? user.department_id
      end
      can :create, Company

      can :manage, Event do |event|
        event.departments.map(&:id).include? user.department_id
      end
      can :create, Event

      can :manage, Placement do |placement|
        placement.company.all_departments.map(&:id).include? user.department_id
      end
      can :create, Placement

      can [:manage, :download_document, :top_5], Student do |student|
        student.departments.map(&:id).include? user.department_id
      end
      can :create, Student
    end

    unless user.type.nil?
      can :stat_show, :all
    end
  end
end
