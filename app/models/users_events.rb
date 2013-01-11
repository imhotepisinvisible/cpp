class UsersEvents < ActiveRecord::Base
  ###################### Declare associations ########################
  belongs_to :student
  belongs_to :event
end
