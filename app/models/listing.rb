class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User", :foreign_key => :host_id
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :change_host_status_to_true

  before_destroy :change_host_status_to_false, if: :only_listing

  def change_host_status_to_true
    host.update(host: true)
  end

  def change_host_status_to_false
    host.update(host: false)
  end

  def only_listing
    host.listings.count == 1
  end

  def average_review_rating
    reviews.pluck(:rating).reduce(:+) / reviews.count.to_f
  end

  def available_at_checkin?(checkin_date)
    # binding.pry
    reservations.where('? BETWEEN reservations.checkin AND reservations.checkout', checkin_date).empty?
  end
  
end
