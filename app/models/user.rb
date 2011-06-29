class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
