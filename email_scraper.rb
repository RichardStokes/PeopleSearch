
# Class to scrape documents for email addresses

class EmailScraper
  
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i

  def EmailScraper.scrape(doc)
    email_addresses = []
    File.open(doc) do |file|
      while line = file.gets
        temp = line.scan(EmailRegex)

        temp.each do |email_address|
          email_addresses << email_address
        end
             
      end
    end 
    return email_addresses
  end
end

