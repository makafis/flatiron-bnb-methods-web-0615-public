class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  # checkin, checkout

  delegate :host, to: :listing

  validates :checkin, :checkout, presence: true

  validate :guest_is_not_host

  validate :listing_available_at_checkin

  def guest_is_not_host
    if guest == host
      errors.add(:reservation, "You cannot reserve your own listing")
    end
  end

  # def listing_available_at_checkin
  #   listing.available_at_checkin?(checkin)
  # end
end
