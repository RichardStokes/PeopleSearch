class EmailScraper
  
  @@email_regex = /\b\w+(?:\.\w+)*@\w+\.\w+\b/
  
  def EmailScraper.get_emails(doc)
    emails = doc.scan(@@email_regex)
    emails.each do |email|
      email.gsub!(/.+@/) { |s| s.downcase }
    end
    if block_given?
      emails.each { |email| yield email }
    else
      emails
    end 
  end
  
end
    
