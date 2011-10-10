#!/usr/bin/env ruby
require 'functions'
require 'google'
require 'emailaddress'
require 'email_scraper'
require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'pp'

puts "Enter your query:"
query = gets.rstrip
urls = Google.perform_search(query, 50)
email_addresses = Array.new
x = 0

urls.each do |url|
  
  puts url
  page_ranking = urls.size - x
  
  puts "Processing: #{url}"
  begin
    text = get_page_body(url)
    emails = EmailScraper.get_emails(text)
    
    if !emails.empty?
      puts "Emails:"
      pp emails
      puts "\n"
    else
      puts "No emails found.\n\n"
    end
    
    emails.each do |email|

      duplicates = email_addresses.select { |e| e.address == email }
      temp = EmailAddress.new(email, page_ranking)
      
      if !duplicates.empty?
        duplicates.each do |duplicate|
          temp.ranking = duplicate.ranking if duplicate.ranking > temp.ranking 
          email_addresses.delete(duplicate)
        end
      end
      
      email_addresses << temp 
    end
  
  rescue
    puts "Error: Couldn't retrieve page.\n\n"
  end
  x = x.succ
end

email_addresses.sort!
email_addresses.reverse!

File.open('google_relevance_results.txt', 'w') do |f|
  email_addresses.each do |e|
    f.write("#{e.address} : #{e.ranking}\n")
  end
end

`gedit google_relevance_results.txt` 
  
  
