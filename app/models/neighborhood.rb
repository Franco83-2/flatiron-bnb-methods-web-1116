class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    self.listings.select do |listing|
      listing.reservations.none? {|res| res.available(checkin, checkout) == true}
    end
  end

  def self.highest_ratio_res_to_listings
   a = self.all.map do |neighborhood|
         res_count = neighborhood.listings.map {|listing| listing.reservations.count}.inject(0){|sum,x| sum + x }
         listings = neighborhood.listings.count
         if neighborhood.listings.count == 0
           listings = 999999999
         end
         (res_count / listings).to_f
       end
       Neighborhood.all[a.index(a.max)]
  end

  def self.most_res
  a =  all.map do |neighborhood|
      b = neighborhood.listings.map {|listing| {listing: listing, count: listing.reservations.count}}.flatten
      {neighborhood: neighborhood, reservations: b.map {|s| s[:count]}.reduce(0, :+)}
    end
    reservations = a.map {|neighborhood| neighborhood[:reservations]}
    res_index = reservations.index(reservations.max)
    a[res_index][:neighborhood]
  end

end
