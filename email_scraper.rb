
# Class to scrape documents for email addresses

class EmailScraper
  
  @@email_regex = /\b[\w\.]+@[\w]+\.[\w]+\b/

  def EmailScraper.scrape(doc)
    email_addresses = []
    addresses = doc.scan(@@email_regex)
    addresses.each { |address| email_addresses << address } 
    return email_addresses
  end
end

