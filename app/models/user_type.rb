class UserType < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, length: { maximum: 55 }

  has_many :users
end
