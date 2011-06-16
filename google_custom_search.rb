require 'rubygems'
require 'json'
require 'uri'
require 'net/https'


class GoogleCustomSearch
  
#  attr_accessor  :params, :key, :cx, :alt, :uri

  
  def initialize(key, cx, alt, query)
    @key = key
    @cx = cx
    @alt = alt
    @query = query
    normalize_query()
    @params = "key=#{@key}&cx=#{@cx}&q=#{@query}&alt=#{@alt}"
    @uri = URI.parse("https://www.googleapis.com/customsearch/v1?#{@params}") 
  end

  def send_query()
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
  
# Search results are represented by hashes,
# held in an array whose key in the JSON hash
# is "items" 

  



