require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_before_checkout?
  validate :checkin_checkout_same_day?
  validate :available?


  def no_checkin?
    checkin == nil ? errors.add(:checkin, "No checkin, loser") : true
  end

  def duration
    (checkout - checkin).to_i
  end

  def available?
    if checkin != nil && checkout != nil
     self.listing.reservations.each do |res|
       dates = (res.checkin..res.checkout).to_a
        if (checkin..checkout).to_a.any? {|day| dates.include?(day)}
          errors.add(:checkin, "Sorry, this date is not available")
        end
      end
    end
  end

  def available(checkin, checkout)
      (checkin.to_datetime - self.checkout.to_datetime).to_i * (self.checkin.to_datetime - checkout.to_datetime) >= 0
  end

  def total_price
    duration * self.listing.price
  end

  def checkin_before_checkout?
    if checkin != nil && checkout != nil
      (checkin - checkout).to_i > 0 ? errors.add(:checkin, "Checkin is after checkout!") : true
    end
  end

  def checkin_checkout_same_day?
     checkin == checkout ? errors.add(:checkin, "Checkin and Checkout are the same day") : true
  end

end
