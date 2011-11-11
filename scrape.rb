require 'rubygems'
require 'bundler'

Bundler.require(:default) if defined?(Bundler)

SiteLayout = {
  :url => 'www.realtor.com',
  :path => '/realestateandhomes-search?mlslid=', 
  :navigation => [ {:link => '#propertyList .resultsItem .itemHeader .wrap a.primaryAction', :list => true}],
  :definition => {
    :description => ['div#PropertyDetails input#PropDetDescAll',["attr", 'value']],
    :address => ['.summary #address h1', ['text']],
    :price   => ['.summary .price', ['text']],
    :beds    => ['.summary .beds-baths-sqft-acres .beds', ['text']],
    :baths   =>  ['.summary .beds-baths-sqft-acres .baths', ['text']],
    :area   =>  ['.summary .beds-baths-sqft-acres .sqft', ['text']],
    :acres   =>  ['.summary .beds-baths-sqft-acres .acres', ['text']]
  }
}

class Scrape
  def initialize
    @navigation = SiteLayout[:navigation]
    @definition = SiteLayout[:definition]
    @path = SiteLayout[:path]
    @site = '%s://%s' % [SiteLayout[:protocol] || 'http', SiteLayout[:url]] 
  end

  def url(path, query='')
    "%s%s%s" % [@site, path, query]
  end
  def navigate(mls)
    response = RestClient.get url(@path, mls)
    doc = Nokogiri::HTML response.body

    # navigate to the page
    @navigation.each do |nav|
      links = doc.css nav[:link]
      links.each do |link|
        yield link[:href]
      end 
    end
  end


  def extract_definition(doc)
    @definition.each do |k, v|
      p "%s: %s" % [k.to_s, doc.css(v[0]).send(*v[1])]
    end
  end

  def extract(mls)
    navigate(mls) do |href|
      p "------------------"
      p "Fetching: " +  url(href)
      response = RestClient.get url(href)
      if response.code == 200
        doc = Nokogiri::HTML response.body
        extract_definition(doc)
      end
    end
  end
end

scraper = Scrape.new 
scraper.extract('11678750')

__END__
http://www.realtor.com/realestateandhomes-search?mlslid=11678750
