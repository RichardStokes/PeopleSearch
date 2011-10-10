#!/usr/bin/env ruby

# Author: Richard Stokes, 2011
# This script runs a custom scoring method designed
# by myself for ranking email addresses in terms of
# their likely relevance to our query.

# Email addresses are ranked on their position
# in the Google search results, their degree of repetition
# within the search result body and the presence within
# the email address string of our query keywords.

require 'google'
require 'email_scraper'
require 'emailaddress'
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'functions'

GOOGLE_RANKING_WEIGHT = 0.05
REPETITION_WEIGHT = 0.8
KEYWORD_PRESENCE_WEIGHT = 0.8

email_addresses = Array.new
puts "What is your query?"
query = gets
keywords = query.split
regexes = Array.new
keywords.each { |keyword| regexes << Regexp.new(keyword, true) }


agent = Mechanize.new

puts "Performing Google search for: #{query}"
urls = Google.perform_search(query)

x = 0
urls.each do |url|
  page_ranking = urls.size - x

  
    
  puts "Processing: #{url}"
  puts "Ranking: #{page_ranking}"
  begin 
    html = get_page_body(url)
  
    temp = EmailScraper.get_emails(html)
    puts "Emails:"
    temp.each { |string| puts string }
    puts "\n"
    temp.each do |address| 

      

      
      # Scans for duplicate email addresses and amends score accordingly
      duplicates = email_addresses.select { |email| email.address == address }
      email = EmailAddress.new(address, page_ranking * GOOGLE_RANKING_WEIGHT)
      if !duplicates.empty?
        email.ranking += (duplicates.size * REPETITION_WEIGHT)
        duplicates.each do |duplicate|
          email_addresses.delete(duplicate)
        end
      end
        
      email_addresses << email
      # Else, if there are duplicates, sum the scores of all the duplicates and
   
    end
    
  rescue
    puts "Error: Couldn't retrieve page\n\n"
  end
  x = x.succ
end

# Adds to an email addresses score if any of the
# search keywords are present in the email address string
email_addresses.each do |email_address|
  regexes.each do |regex|
    email_address.ranking += (1 * KEYWORD_PRESENCE_WEIGHT) if email_address.address.match(regex)
  end
end

email_addresses.sort!
email_addresses.reverse!

# Write each address and it's ranking to file
filename = 'custom_scoring_results.txt' 
File.open(filename, 'w') do |f|
  email_addresses.each do |email|
    f.write("#{email.address} : #{email.ranking}\n")
  end
end 


  
