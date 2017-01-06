class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(checkin, checkout)
    self.listings.select do |listing|
      listing.reservations.none? {|res| res.available(checkin, checkout) == true}
    end
  end

  def self.highest_ratio_res_to_listings
   a = self.all.map do |city|
         res_count = city.listings.map {|listing| listing.reservations.count}.inject(0){|sum,x| sum + x }
         res_count.to_f / city.listings.count
       end
       City.all[a.index(a.max)]
  end

  def self.most_res
  a =  all.map do |city|
      b = city.listings.map {|listing| {listing: listing, count: listing.reservations.count}}.flatten
      {city: city, reservations: b.map {|s| s[:count]}.reduce(0, :+)}
    end
    reservations = a.map {|city| city[:reservations]}
    res_index = reservations.index(reservations.max)
    a[res_index][:city]
  end


end
