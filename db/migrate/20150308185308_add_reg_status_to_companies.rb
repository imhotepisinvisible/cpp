class AddRegStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :reg_status, :integer, :default => 0
    ActiveRecord::Base.connection.execute('UPDATE companies SET reg_status=(SELECT status FROM department_registrations WHERE companies.id = company_id)')
  end
end
