module CustomersHelper

  def last_location(lat, long)
    query = Geocoder.search("#{lat},#{long}").first
    if query
      return query.address
    else
      return "N/A"
    end
  end

end
