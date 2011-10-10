#!/usr/bin/env ruby

# Author: Richard Stokes, 2011
# Script that tests email search using an edit-distance metric
# and a probable email address constructed from keywords,
# e.g. richardstokes@ucd.ie would be a probable email address for
# the keywords "Richard Stokes UCD"

# In this scoring metric, the lower the score, the
# likelier an email address is to be acurate

require 'google'
require 'emailaddress'
require 'email_scraper'
require 'editdistance'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'functions'
require 'pp'


# Creates and gathers the relevant containers and input data
email_addresses = Array.new
puts "Who are you searching for?"
person = gets.rstrip
puts "Enter a related keyword(s) to aid the search:"
keywords = gets.rstrip
likely_email = create_email(person, keywords, "ie")
puts "Likely email: #{likely_email}"

# Performs the google search
puts "\nPerforming search:"
urls = Google.perform_search("#{person} #{keywords}", 50)

urls.each do |url|
  
  puts url
  # skip .pdf and .doc files - unable to effectively parse text contents
  next if url.match(/(.pdf|.doc)\z/)

  begin
    html = get_page_body(url)
  
    temp = EmailScraper.get_emails(html)
    
    if !temp.empty?
      puts "Emails:"
      pp temp
      puts "\n"
    else
      puts "No emails found.\n\n"
    end
    
    temp.each do |address|
      
      
      duplicates = email_addresses.select { |email| email.address == address }
      duplicates.each { |duplicate| email_addresses.delete(duplicate) } if !duplicates.empty?
      
      ranking = EditDistance.dameraulevenshtein(likely_email, address)
      email_addresses << EmailAddress.new(address, ranking)
    end

  rescue
    puts "Error: Couldn't retrieve page.\n\n"
  end

end

  
# Sort the email addresses according to their Damerau-Levenshtein distance
# from the probable email address constructed at the start  
email_addresses.sort!

# Write each address and it's ranking to file
filename = 'edit_distance_results.txt' 
File.open(filename, 'w') do |f|
  email_addresses.each do |email|
    f.write("#{email.address} : #{email.ranking}\n")
  end
end

`gedit edit_distance_results.txt`  
  
 
