require 'net/http'
require 'uri'
require 'rubygems'
require 'nokogiri'

class Google
    
  def Google.perform_search query, num_results = 100, domain = "ie"
    
    query.rstrip!
    query.gsub!(/\s/, "+")
    query.gsub!(/\"/, "%22")
    # Determine number of full pages and additional results
    query_urls = []
    results = []
    num_full_pages = num_results / 100
    num_additional_results = num_results % 100
    
    # Construct all the query URLs we need to GET
    x = 0
    num_full_pages.times do
      query_urls << "http://www.google.#{domain}/search?q=#{query}&num=100&start=#{x * 100}&safe=off"
      x = x.next
    end
    
    if num_additional_results != 0
      query_urls << "http://www.google.#{domain}/search?q=#{query}&num=#{additional_results}&start=#{x * 100}&safe=off"
    end
    
    # GET each query URL, and proccess it's content for
    # result links (of the CSS class "h3.r a" for Google)
    query_urls.each do |url|
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      doc = Nokogiri::HTML(response.body)
      doc.css("h3.r a").each { |link| results << link['href'] if link['href'] =~ /^https?:/ }
    end
    
    # return the URLs of the search results
    results
  end
  
end
      
      
      
      
      
