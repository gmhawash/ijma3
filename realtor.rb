require 'site_layout'
class Realtor < SiteLayout
  def initialize
    super
    @special_fields = {
      :price            => {:matcher => %r(^price$)i},
      :property_features => {:processor => 'html'}
    }
    @general_fields = [
      :beds, :baths, :house_size, :lot_size, :property_type, :year_built, :style, :stories,
      :fireplace_features, :heating_features, :exterior_construction, :roofing, 
      :interior_features, :exterior_features, :last_refreshed, :mls_id, :listing_brokered_by,
      :garage, :property_features
    ]
  end

  def url
    'www.realtor.com'
  end

  def path
    '/realestateandhomes-search?mlslid='
  end

  def navigation
    [ {:link => '#propertyList .resultsItem .itemHeader .wrap a.primaryAction', :list => true}]
  end

  def definition
    {
    :property_details => ['div#PropertyDetails table tr', 'property_details'],
    :property_photos  => ['script', 'property_photos'],
    }
  end

  def add(th, td)
    map.each do |k,v|    
      if th =~ v[:matcher]
        @data[k] = (v[:processor] ? send(v[:processor], td) : td.text).gsub(/\s+/, ' ').strip
      end
    end
  end

  def property_details(nodes)
    # Find matching <th></th><td></td>
    nodes.each do |node|
      theads = node.css("th")
      theads.each do |th|
        add(th.text, th.next) 
      end
    end
    @data.each do |k,v|
      p [k, v]
    end
    nil
  end

  def extract_photo_urls(node)
    node = node.to_s
    first = 0
    while(first = node.index(/file_url/, first)) do
      last = node.index(',', first) 
      node[first..last] =~ /file_url.*:\"(.*)\"/
      yield $1.gsub('\\','') 
      first = last
    end
  end

  def property_photos(nodes)
    nodes.each do |node|
      extract_photo_urls(node) do |url|
        @photos << url
      end
    end
  end
end

