require 'site_layout'
class Realtor < SiteLayout
  def initialize
    super
    @special_fields = {
      :price            => {:matcher => %r(^price$)i},
    }
    @general_fields = [:beds, :baths, :house_size, :lot_size, :property_type, :year_built, :style, :stories]
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
    }
  end

  def add(th, td)
    map.each do |k,v|    
      if th =~ v[:matcher]
        @data[k] =  td.text.strip
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
    p @data
  end
end

