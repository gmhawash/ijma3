require 'rubygems'
require 'bundler'

Bundler.require(:default) if defined?(Bundler)

SiteLayout = {
  :url => 'www.realtor.com',
  :navigation => [ {:link => '#propertyList .resultsItem .itemHeader .wrap a.primaryAction', :index => true},





}

class Scrape
  response = RestClient.get 'http://www.realtor.com/realestateandhomes-search?mlslid=11401194'
  doc = Nokogiri::HTML response.body
end
