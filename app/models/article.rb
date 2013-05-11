class Article < ActiveRecord::Base
  attr_accessible :content, :title, :subtitle, :user_id, :likes, :category_id, :image

  belongs_to :user
  belongs_to :category
  has_many :comments

  validates :title, presence: true, length: { maximum: 55 }
  validates :content, presence: true
  validates :subtitle, presence: true
  validates :category_id, presence: true
  validates :user_id, presence: true
end
