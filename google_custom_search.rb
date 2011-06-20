require 'rubygems'
require 'json'
require 'uri'
require 'net/https'


class GoogleCustomSearchQuery
  
  def initialize(key, cx, alt, query)
    @key = key
    @cx = cx
    @alt = alt
    @query = query
    normalize_query()
  end

  def send_query(query)
    params = "key=#{@key}&cx=#{@cx}&q=#{query}&alt=#{@alt}"
    uri = URI.parse("https://www.googleapis.com/customsearch/v1?#{params}") 
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    data = http.request(Net::HTTP::Get.new(@uri.request_uri))
    json = JSON.parse(data.body)
  end
  
  def normalize_query
    @query.gsub!(/\"/, "%22")
    @query.gsub!(/\s/, "+")
  end   
end


  



