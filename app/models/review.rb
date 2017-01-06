class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :authentic

  def authentic
    other_stuff ? true : errors.add(:base, "Sorry, this stay never occurred")
  end

  def other_stuff
    self.reservation && self.reservation.status == "accepted" && (self.reservation.checkout.to_time < Date.today.to_time)
  end
end
