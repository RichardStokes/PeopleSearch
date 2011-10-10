# Author: Richard Stokes, 2011
# Collection of useful functions related to the application
require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Function for creating likely email addresses from names and keywords,
# e.g. create_email("Richard Stokes", "UCD", :ie) => "richardstokes@ucd.ie"
def create_email(name, keywords, domain)
  name.gsub!(/\s/, "")
  keywords.gsub!(/\s/, "")
  name.downcase!
  keywords.downcase!
  "#{name}@#{keywords}.#{domain}"  
end

# Function for performing a GET request on a URL, then returning the inner text
# of the HTML document (i.e. removing the tags)
def get_page_body(url) 
  doc = Nokogiri::HTML(open(url))
  text = doc.css("body").inner_html
end

# Takes a string and splits it up into its
# constituent tokens, returned as an array
def tokenize_string(string)
  words = string.split(/\W+/)
  words.reject { |s| s.nil? or s.empty?}  # Removes all nil and empty strings from the array
  words.each { |word| word.downcase! }
end
