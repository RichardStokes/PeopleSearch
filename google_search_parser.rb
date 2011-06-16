require 'uri'
require 'net/http'

class GoogleSearchParser

def initialize(query)
	normalize_query
	@query = query
end

def send_query
	query_url = "http://www.google.com/search?q=#{@query}"
	uri = URI.parse(query_url)
	result = Net::HTTP.get_request(uri.host, uri.path)
	
	
