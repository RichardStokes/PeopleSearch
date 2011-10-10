#!/usr/bin/env ruby

# Author: Richard Stokes, 2011
# Using tf-idf (term frequency - inverse document frequency)
# weights, this script performs query expansion on a google query
# in order to get more relevant results.

require 'google'
require 'tf-idf'
require 'functions'
require 'pp'

freqs = Hash.new(0)
documents = Array.new

test_query = "Paul Stokes UCD"
urls = Google.perform_search(test_query, 1)

urls.each do |url|
  begin
  text = get_page_body(url)
  documents << text
  
  terms = tokenize_string(text) 
  puts "#{url} : #{terms.size}"
  terms.each { |term| freqs[term] += 1}
  
  rescue
    puts "Error: Couldn't retrieve page"
  end
end

freqs = freqs.sort_by { |x,y| y }
freqs.reverse!
file = File.open('term_count.txt', 'w')
freqs.each { |word, freq| file.write(word+' '+freq.to_s+"\n") }
