class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.map do |listing|
      listing.reservations.map do |reservation|
        reservation.guest
      end
    end.flatten
  end

  def host_reviews
    self.listings.map do |listing|
      listing.reviews
    end.flatten
  end

  def hosts
    self.reviews.map do |review|
      review.reservation.listing.host
    end.flatten.uniq
  end

end
