class Reminder
	@queue = :reminders

  def self.perform
  	sixMonthsAgo = Time.now - 6.months
    Student.find_each(:conditions => ["updated_at <= ?",sixMonthsAgo]) do |student|
    	UserMailer.account_deactivated(student).deliver  
    end  
  end
end	