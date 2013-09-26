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
      can :create, CompanyAdministrator
      can :read, Department
    when "Student"
      can :manage, Student, :id => user.id
      can [:read, :register, :unregister], Event do |event|
        share_departments?(user, event)
      end
      can :read, Placement do |placement|
        share_departments?(user, placement.company)
      end
      can [:read, :download_document, :set_rating], Company do |company|
        share_departments?(user, company)
      end
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
      can [:read, :download_document], Student do |student|
        member_dept_regs = user.company.department_registrations.where(:status => 3)
        member_depts = member_dept_regs.map{ |r| r.department.id }
        student_depts = student.departments.map(&:id)
        intersect?(member_depts, student_depts)
      end
    when "DepartmentAdministrator"
      can :manage, DepartmentAdministrator, :id => user.id
      can :manage, CompanyAdministrator do |company_admin|
        company_admin.company.all_departments.map(&:id).include? user.department_id
      end
      can :manage, Department, :id => user.department_id
      #can :manage, Email do |email|
      #  email.company.all_departments.map(&:id).include? user.department_id
      #end
      can :manage, Email
      can :manage, Company do |company|
        company.all_departments.map(&:id).include? user.department_id
      end
      can :manage, Event do |event|
        event.departments.map(&:id).include? user.department_id
      end
      can :manage, Placement do |placement|
        placement.departments.map(&:id).include? user.department_id
      end
      can :manage, Student do |student|
        student.departments.map(&:id).include? user.department_id
      end
    end

    unless user.type.nil?
      can :stat_show, :all
    end
  end

  # Returns true if entities a and b share departments
  # a - list of departments
  # b - list of departments
  def share_departments?(a, b)
    intersect?(a.departments.map(&:id), b.departments.map(&:id))
  end

  # Returns true if lists a and b intersect, false otherwise
  # a - list of objects
  # b - list of objects
  def intersect?(a, b)
    !(a & b).empty?
  end
end
