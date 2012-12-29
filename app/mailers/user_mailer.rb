class UserMailer < ActionMailer::Base
  default from: "impdoccpp@gmail.com"

  def bulk_email(email_id)
  	@users = getUsersByInterest(email_id)
  	@email = Email.find(email_id)
  	puts "Size of array:"
  	puts @users.size
  	@users.each do |user|

  		
  		mail(:to => user.email,
  				 :subject => @email.subject) do |format|
  			format.html { render :inline => parseEmail(@email.body), :locals => {:user => user} }
  		end
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
    subject = "CPP Password Reset Notification"
    @password = password
    mail(:to => user.email, :subject => subject)
  end
end
