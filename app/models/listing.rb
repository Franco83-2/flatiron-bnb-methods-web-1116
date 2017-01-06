class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  after_create :host?
  after_destroy :not_host?

  def average_review_rating
    (self.reviews.map {|review| review.rating}).inject(0){|sum,x| sum + x } / self.reviews.count.to_f
  end

  def host?
   self.host.update(host: true)
  end

  def not_host?
    if self.host.listings == []
      self.host.update(host: false)
    end
  end

end
