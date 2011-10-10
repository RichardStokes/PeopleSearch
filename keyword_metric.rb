#!/usr/bin/env ruby
require 'functions'
require 'google'
require 'email_scraper'
require 'emailaddress'
require 'pp'

puts "Enter your query"
query = gets.rstrip
keywords = query.split
regexes = Array.new
keywords.each { |keyword| regexes << Regexp.new(keyword, true) }

urls = Google.perform_search(query, 50)
email_addresses = Array.new

urls.each do |url|
  puts "Processing: #{url}"
  
  begin
    text = get_page_body(url)
    EmailScraper.get_emails(text) { |email| email_addresses << email }
    
    if !emails.empty?
      puts "Emails:"
      pp emails
      puts "\n"
    else
      puts "No emails found.\n\n"
    end
    
  rescue
    puts "Error: Couldn't retrieve page.\n\n"
  end
end

email_addresses.uniq!
ranked_emails = Hash.new(0)
email_addresses.each do |email|
  regexes.each do |regex|
    ranked_emails[email] += 1 if email.match(regex)
  end
end

ranked_emails = ranked_emails.sort { |x,y| y[1] <=> x[1] }

File.open('keyword_metric_results.txt', 'w') do |f|
  ranked_emails.each { |element| f.write(element.shift + " " + element.shift.to_s + "\n") }
end

`gedit keyword_metric_results.txt`
  

