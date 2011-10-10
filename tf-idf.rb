module InformationRetrieval
  
  include Math
  
  def InformationRetrieval.term_frequency(term, document)
    term.downcase!
    document.downcase!
    words = document.scan(/\w+/)
    count = 0
    words.each do |word|
      count += 1 if word == term
    end
    n = words.length
    return count.to_f / n.to_f
  end
  
  def InformationRetrieval.inverse_document_frequency(term, documents)
    top = documents.size
    bottom = documents.collect { |doc| doc.match(term) }
    return Math.log(top.to_f / bottom.to_f)
  end
  
  def InformationRetrieval.tf_idf(term, document, documents)
    return InformationRetrieval.term_frequency(term, document) * InformationRetrieval.inverse_document_frequency(term, documents)
  end
  
end

