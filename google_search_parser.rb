require 'rubygems'
require 'nokogiri'
require 'uri'
require 'net/http'

class GoogleSearchQuery

  def initialize(query)
	  @query = query
	  normalize_query
  end

  # Sends the query, and parses the resulting page for the search result hyperlinks.
  # Returns an array of URL 
  def send_query
	  query_url = "http://www.google.com/search?&q=#{@query}"
	  uri = URI.parse(query_url)
	  result = Net::HTTP.get_response(uri)
	  result_html = result.body
	  
	  links = []
	  doc = Nokogiri::HTML(result_html)
    doc.css("h3.r a").each do |link|
       links << link['href'] if link['href'] =~ /^https?:/
    end
    links
  end

  def normalize_query
    @query.gsub!(/\"/, "%22")
    @query.gsub!(/\s/, "+")
  end 
	
end

puts "What is your search query?"
query = gets
google_query = GoogleSearchQuery.new query
results = google_query.send_query
puts results


