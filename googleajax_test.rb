require 'rubygems'
require 'googleajax'

GoogleAjax.referer = "ucd.ie"
results = GoogleAjax::Search.web("Hello World!")
puts results.class
results = results.to_hash
results.each { |result| puts result.to_s}
