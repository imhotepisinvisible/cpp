class Reminder
	@queue = :reminders

  def self.perform
  	#sixMonthsAgo = Time.now - 6.months
  	sixMonthsAgo = Time.now - 1.hour
    Student.find_each(:conditions => ["updated_at <= ?",sixMonthsAgo]) do |student|
    	UserMailer.account_reminder(student).deliver  
    end  
  end
end	