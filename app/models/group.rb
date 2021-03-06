class Group < ActiveRecord::Base
  attr_accessible :canton_id, :city, :description, :latitude, :longitude, :name, :npa, :street, :website

  belongs_to :canton
  belongs_to :style, class_name: G::Style, :dependent => :destroy
  has_many :pages, class_name: G::Page, :dependent => :destroy
  has_many :comp_groups, class_name: G::CompGroup, :dependent => :destroy
  has_many :modules, class_name: G::Module, through: :comp_groups

  has_many :events, class_name: G::Event
  has_many :news, class_name: G::New
  has_many :galleries, class_name: G::Gallery
  has_many :images, class_name: G::Image

  validates :canton_id, presence: true
  validates :city, presence: true, length: { maximum: 55 }
  validates :street, presence: true, length: { maximum: 110 }
  validates :npa, presence: true, length: { is: 4 }, numericality: true
  validates :description, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  validates :name, presence: true, length: { maximum: 55 }, uniqueness: true
  validates :website, length: { maximum: 55 }
  validates :url, uniqueness: true, presence: true, format: { with: /\A[a-z0-9-]+\z/ }, length: { maximum: 55 }
  validate :url_already_taken?

  def to_param
    url
  end

  def upcoming_events
    @upcoming_events ||= events.where('date >= ?', Time.zone.now).order('date ASC')
  end

  def last_date
    @last_date ||= if events.last.present? && events.last.date?
      if events.last.date < Date.today + 15.day
        Date.today + 15.day
      else
        events.last.date.to_date
      end
    else
      Date.today + 15.days
    end
  end

  def valid_news
    @valid_news ||= news.where('date_exp >= ?', Time.zone.now).order('date_exp ASC')
  end

  private

  def url_already_taken?
    if !url.nil? && Rails.application.routes.routes.map{ |route| route.path.spec.to_s }.include?('/' + url + '(.:format)')
      errors.add(:url, "n'est pas disponible.")
    end
  end

end
