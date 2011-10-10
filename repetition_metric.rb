#!/usr/bin/env ruby

require 'functions'
require 'google'
require 'emailaddress'
require 'email_scraper'
require 'pp'


puts "Enter your query:"
query = gets.rstrip
urls = Google.perform_search(query, 50)
email_addresses = Array.new
ranked_emails = Hash.new

urls.each do |url|
  
  puts "Processing URL: #{url}"
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
    
    emails.each { |address| email_addresses << address }
  rescue
    puts "Error: Couldn't retrieve page.\n\n"
  end
end  

unique_emails = email_addresses.uniq
unique_emails.each do |e|
  ranked_emails[e] = email_addresses.count(e)
end

ranked_emails = ranked_emails.sort { |x,y| y[1] <=> x[1] }

File.open('repetition_metric_results.txt', 'w') do |f|
  ranked_emails.each { |element| f.write(element.shift + " " + element.shift.to_s + "\n") }
end

`gedit repetition_metric_results.txt`
