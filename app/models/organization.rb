class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :reports

  validates :name, :format => /^[a-z\-]+$/, :presence => true
  validates :long_name, :presence => true

  def to_param
    name
  end
end
