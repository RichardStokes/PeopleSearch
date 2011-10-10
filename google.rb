require 'net/http'
require 'open-uri'
require 'rubygems'
require 'nokogiri'

class Google
    
  def Google.perform_search(query, num_results = 100, domain = "ie")
    
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
      query_urls << "http://www.google.#{domain}/search?q=#{query}&num=#{num_additional_results}&start=#{x * 100}&safe=off"
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
  
  private
  
  def Google.get_results(query_urls)
    threads, results = [], []
    query_urls.each do |url|
      
      threads << Thread.new(url) do |page|
        file = open(page)
        doc = Nokogiri::HTML(file.read)
        doc.css("h3.r a").each { |link| results << link['href'] if link['href'] =~ /^https?:/ }
      end
    end
    
    threads.each { |thread| thread.join } 
    results   
  end
  
  def Google.sanitize_query!(query) 
    query.rstrip!
    query.gsub!(/\s/, "+")
    query.gsub!(/\"/, "%22")
  end
  
  def Google.construct_query_urls(query, num_results = 100, domain = ".com")
    domain = domain
    query = query
    num_results = num_results
    
    query_urls = []
    num_full_pages = num_results / 100
    num_additional_results = num_results % 100
    
    x = 0
    num_full_pages.times do
      query_urls << "http://www.google.#{domain}/search?q=#{query}&num=100&start=#{x * 100}&safe=off"
      x = x.next
    end
    
    if num_additional_results != 0
      query_urls << "http://www.google.#{domain}/search?q=#{query}&num=#{num_additional_results}&start=#{x * 100}&safe=off"
    end
    
    query_urls
  end
  
  def Google.perform_search2(params)
    query = params[:query] || ""
    num_results = params[:num_results] || 100
    domain = params[:domain] || "com"
    
    Google.sanitize_query!(query)
    query_urls = Google.construct_query_urls(query, num_results, domain)
    Google.get_results(query_urls)
  end
    
    
  
end
      
      
      
      
      
