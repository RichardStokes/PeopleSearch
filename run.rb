#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'google_search_parser.rb'
require 'email_scraper.rb'

puts "What is your query?"
query = gets
puts "How many results would you like returned?"
num_results = gets.to_i

query = GoogleSearchQuery.new(query, num_results)
results = query.send_query
addresses = []
linkedin_pages = []

puts "\nResults:\n"
results.each { |result| puts result }

results.each do |link|
  uri = URI.parse(link)
  html = Net::HTTP.get_response(uri).body
  text = Nokogiri::HTML(html).text
  emails = EmailScraper.scrape(text)
  
  emails.each do |address| 
    addresses << address
  end 
  
  linkedin_pages << link if link.match(/^http:\/\/.+\.linkedin.com\/(pub(?!\/dir)|in)/)
end 

puts "\nAddresses:\n"
addresses.each { |address| puts address} 

puts "\nLinkedIn Pages:\n"
linkedin_pages.each { |page| puts page }




