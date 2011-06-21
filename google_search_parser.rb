require 'rubygems'
require 'nokogiri'
require 'uri'
require 'net/http'

class GoogleSearchQuery
  
  attr_accessor :query, :num_results, :query_urls, :domain

  def initialize(query, num_results, domain = "ie")
	  @query = query.rstrip
	  normalize_query
	  @num_results = num_results.to_i
    @domain = domain
	  @query_urls = create_query_urls
  end

  # Sends the query, and parses the resulting page for the search result hyperlinks.
  # Returns an array of URL 
  def send_query
    	  
	  # Creates a new array for the result links, then
	  # sends a HTTP GET request for each query URL
	  links = []
	  @query_urls.each do |url|
	    
	    uri = URI.parse(url)
	    result = Net::HTTP.get_response(uri)
	    result_html = result.body
	    
	    # Nokogiri parses the html for each pages of results,
	    # extracting the result URLs and placing the in our array  
	    scrape_results(result_html).each do |search_result|
	      links << search_result
      end
    end
    return links
  end
  
  # Retrieves the URLs for search results
  # from a Google results page
  def scrape_results(results_page)
    doc = Nokogiri::HTML(results_page)
    links = []
    doc.css("h3.r a").each { |link| links << link['href'] if link['href'] =~ /^https?:/ }
    return links
  end

  # Transforms a regular string into a Google
  # query string.
  def normalize_query
    @query.gsub!(/\"/, "%22")
    @query.gsub!(/\s/, "+")
  end
  
  def create_query_urls()
    num_full_pages = @num_results / 100
    additional_results = @num_results % 100
    query_urls = []
    
    x = 0
    num_full_pages.times do
      query_urls << "http://www.google.#{@domain}/search?q=#{@query}&num=100&start=#{x * 100}&safe=off"
      x = x.next
    end
    
    if additional_results != 0
      query_urls << "http://www.google.#{@domain}/search?q=#{@query}&num=#{additional_results}&start=#{x * 100}&safe=off"
    end
    return query_urls
  end
	
end



