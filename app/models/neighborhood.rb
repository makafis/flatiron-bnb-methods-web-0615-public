class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    all.max_by {|n| n.ratio_res_to_listings}
  end

  def self.most_res
    all.max_by {|n| n.reservations.count}
  end

  def ratio_res_to_listings
    if listings.count != 0
      reservations.count / listings.count
    else
      0
    end
  end

  def neighborhood_openings(start_date, end_date)
    listings.joins(:reservations).where('(checkin NOT BETWEEN ? AND ?) AND (checkout NOT BETWEEN ? and ?)', start_date, end_date, start_date, end_date)
  end


end
