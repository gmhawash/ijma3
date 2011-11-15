require 'rubygems'
require 'bundler'
require 'realtor'

Bundler.require(:default) if defined?(Bundler)

class Scrape
  def initialize(layout)
    @layout = layout
    @navigation = layout.navigation 
    @definition = layout.definition 
    @path = layout.path
    @site = '%s://%s' % [layout.protocol, layout.url] 
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
      begin
        p "%s: %s" % [k.to_s, @layout.send(v[1], doc.css(v[0]))]

      rescue Exception => e
        # maybe should send an email here!!!
        p [k, v, e.message]
      end
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

scraper = Scrape.new (Realtor.new)
scraper.extract('11521567')

__END__
http://www.realtor.com/realestateandhomes-search?mlslid=11678750
