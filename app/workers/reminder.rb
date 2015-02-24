class Reminder
	@queue = :reminders

  def self.perform
  	sixMonthsAgo = Time.now - 6.months
    Student.find_each(:conditions => ["updated_at <= ?",sixMonthsAgo]) do |student|
    	UserMailer.account_reminder(student).deliver  
    end  
  end
end	