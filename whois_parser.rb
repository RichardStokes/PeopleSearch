#!/usr/bin/env ruby

# A WHOIS parser for the .ie WHOIS server

regexp = /person:\t\w+/



while line = gets
  if line ~= regexp
    puts line
  end
end
