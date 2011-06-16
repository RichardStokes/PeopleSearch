#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'uri'
require 'net/http'
require 'google_custom_search.rb'

key = "AIzaSyCoe7rUNfWYoXO_e6gwmyJGyyY1VSbddjE"
cx = "006511033357032373921:zxj5gjholro" 
cref = ""
alt = "json"

puts "What is your search query?"
query = gets

searcher = GoogleCustomSearch.new(key, cx, alt, query)



json = searcher.send_query
json = json["items"]

json.each do |item|
  puts item["link"]
end

#filename = 'testfile.json'
#File.open(filename, 'w') { |f| f.write(data)}
#`gedit #{filename}`



