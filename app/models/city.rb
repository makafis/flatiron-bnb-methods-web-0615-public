class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def self.most_res
    all.max_by {|city| city.reservations.count}
  end

  def self.highest_ratio_res_to_listings
    all.max_by {|city| city.ratio_res_to_listings}
  end

  def ratio_res_to_listings
    reservations.count / listings.count
  end

  def city_openings(start_date, end_date)
    listings.joins(:reservations).where('(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? and ?)', start_date, end_date, start_date, end_date)
  end

end

