module CustomersHelper

  def last_location(lat, long)
    query = Geocoder.search("#{lat},#{long}").first
    return query.address
  end

end
