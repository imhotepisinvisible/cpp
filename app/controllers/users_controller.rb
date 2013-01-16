class UsersController < ApplicationController
  impressionist

  respond_to :json

  # Allows user to change their password
  # Assumes user is logged in and therefore accessible via current_user
  # 
  # PUT /users/change_password
  # PUT /users/change_password.json
  def change_password
    @user = current_user
    if params[:password] == params[:password_confirmation]
      if @user && @user.authenticate(params[:old_password])
        @user.password = params[:password]

        if @user.save
          head :no_content
        else
          @user.errors.add(:user, 'Unable to change password')
          respond_with @user, status: :unprocessable_entity
        end
      else
        @user.errors.add(:user, 'Unable to change password - old password incorrect')
        respond_with @user, status: :unprocessable_entity
      end
    else
      # Passwords do not match
      @user.errors.add(:user, 'Unable to change password - new passwords do not match')
      respond_with @user, status: :unprocessable_entity
    end
  end

  # Resets users password to a new 8 character secure random string
  # Emails user password
  #
  # /user/forgot_password
  def forgot_password
    @user = User.find_by_email(params[:email])
    if @user == nil
      @user = User.new
      @user.errors.add(:user, 'No such email address exists')
      respond_with @user, status: :unprocessable_entity
    else
      password = SecureRandom.hex(8)
      @user.password = password
      if @user.save
        UserMailer.password_reset_email(@user,password).deliver
        head :no_content
      else
        @user.errors.add(:user, 'Unable to reset password')
        respond_with @user, status: :unprocessable_entity
      end
    end
  end
end
