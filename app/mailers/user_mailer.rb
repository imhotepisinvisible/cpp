class UserMailer < ActionMailer::Base
  #include Resque::Mailer
  default from: "no-reply@cpp.doc.ic.ac.uk"

  def send_email(address, subject, body)
    puts "Sending email to " + address
    mail(:to => address, :subject => subject) do |format|
      format.html { render :inline => body }
    end
  end

  def getUsersByInterest(email_id)
  	#TODO when Tags are done.
  	User.scoped
  end

  def parseEmail(body)
  	templates = Hash.new()
  	templates[/\{\{FIRSTNAME\}\}/] = "<%= user.first_name %>"
  	templates[/\{\{LASTNAME\}\}/] = "<%= user.last_name %>"

  	templates.each do |key,value|
  		body.gsub!(key,value);
  	end
  	body
  end

  def password_reset_email(user, password)
    puts "PASSWORD RESET EMAIL"
    subject = "CPP Password Reset Notification"
    @password = password
    mail(:to => user.email, :subject => subject)
  end

  def account_terminated(user)
    puts "ACCOUNT TERMINATED EMAIL"
    subject = "CPP Account Deleted"
    mail(:to => user.email, :subject => subject)
  end

  def account_deactivated(user)
    puts "ACCOUNT_DEACTIVATED_EMAIL"
    subject = "CPP Account Deactivated"
    @name = user.first_name
    @url = "https://cpp.doc.ic.ac.uk/"
    mail(:to => user.email, :subject => subject)
  end

    def account_reminder(user)
    puts "ACCOUNT_REMINDER_EMAIL"
    subject = "CPP Account Reminder"
    @name = user.first_name
    @url = "https://cpp.doc.ic.ac.uk/"
    mail(:to => user.email, :subject => subject)
  end
end
