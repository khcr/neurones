class Event < ActiveRecord::Base
  attr_accessible :date, :events_type_id, :image_id, :info, :lieu, :remarque, :theme

  validates :date, presence: true
 	# validates :events_type_id, presence: true
  validates :theme, presence: true, length: { maximum: 55 }
  validates :lieu, presence: true, length: { maximum: 55 }
  validates :info, presence: true
end
