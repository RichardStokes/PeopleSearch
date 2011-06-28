#!/usr/bin/env ruby

require 'net/https'
require 'uri'
require 'google_search_parser.rb'
require 'email_scraper.rb'
require 'page.rb'

puts "What is your query?"
query = gets
puts "How many results would you like returned?"
num_results = gets.to_i

query = GoogleSearchQuery.new(query, num_results)
results = query.get_results
addresses = []
linkedin_pages = []
facebook_pages = []
twitter_pages = []

results.each do |link|
  
  if !link.match(/\.pdf+/)
    puts "Processing: #{link}\n"
    page = Page.new(link)
    emails = EmailScraper.scrape(page.content)
    
    emails.each do |address|
      addresses << address
    end
  
  linkedin_pages << page if page.url.match(/^http:\/\/.+\.linkedin\.com\/(pub(?!\/dir)|in)/)
  facebook_pages << page if page.url.match(/^http:\/\/www\.facebook\.com\//)
  twitter_pages <<  page if page.url.match(/^https?:\/\/(www\.)?twitter\.com\/[^\/]*/)
  end
end

if !linkedin_pages.empty?
  puts "\nLinkedIn pages:\n"
  linkedin_pages.each { |page| puts page.url }
end

if !facebook_pages.empty?
  puts "\nFacebook pages:\n"
  facebook_pages.each { |page| puts page.url }
end

if !twitter_pages.empty?
  puts "\nTwitter pages:\n"
  twitter_pages.each { |page| puts page.url }
end







