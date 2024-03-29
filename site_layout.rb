class SiteLayout
  attr_accessor :data, :general_fields

  def initialize
    @data = {}
    @photos  = []
    @general_fields = []
  end

  def protocol
    'http'
  end

  def text(node)
    node.text
  end

  def value(node)
    node.attr('value')
  end

  def html(node)
    node.to_html
  end

  def map
    return @hash if @hash

    @hash = @special_fields
    @general_fields.each do |key|
      @hash[key] ||= {}
      @hash[key][:matcher] = %r(#{key.to_s.sub('_', '\s*')})i 
    end
    @hash
  end
end

