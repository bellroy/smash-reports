class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :trackable, :validatable, :timeoutable

  attr_accessible :email, :password, :password_confirmation

  has_and_belongs_to_many :organizations
end
