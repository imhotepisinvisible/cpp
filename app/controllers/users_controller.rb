class UsersController < ApplicationController
  respond_to :json

  # PUT /users/change_password
  # PUT /users/change_password.json
  def change_password
    @user = User.find_by_email(params[:email])
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

  def forgot_password
    @user = User.find_by_email(params[:email])
    if @user == nil
      # TODO: Does this get saved into the db? I don't want it to!
      @user = User.new
      @user.errors.add(:user, 'No such email address exists')
      respond_with @user, status: :unprocessable_entity
    else
      # TODO GENERATE SECURE NEW PASSWORD AND EMAIL TO STUDENT
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
