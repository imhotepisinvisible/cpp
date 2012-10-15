class SiteController < ApplicationController
  def index
    # No Variables/Code Necessary Right now
  end

  def sample_student_dashboard
    # No Variables/Code Necessary Right now
  end

  def sample_student_companies

  end

  def sample_student_company

  end

  def sample_company_dashboard

  end

  def sample_company_students

  end

  def sample_company_student

  end

  def sample_admin_students
    @people = ["Peter Hamilton",
               "Tom Wilshere",
               "Jack Stevenson",
               "Tom Wilding",
               "Sarah Tattersall"]
    @years = ["First Year", "Second Year"]
  end

  def sample_admin_companies

  end

  def sample_admin_placements

  end

end
