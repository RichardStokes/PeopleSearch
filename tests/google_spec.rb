# google_spec.rb
require 'google.rb'

describe Google do
  
  describe "sanitize query" do
     
     it "should properly sanitize the input query" do
       string = 'this is a "query"'
       Google.sanitize_query(string).should == 'this+is+a+%22query%22'
     end
  end
  
  describe 'query url construction' do
    
    it 'should construct proper query urls' do
      
      query = Google.sanitize_query('this is a "query"')
      puts query
      results = 250
      urls = Google.construct_query_urls(:query => query, :domain => 'ie', :num_results => results)
      
      first = Regexp.new("http://www.google.ie/search?q=#{query}&num=100&start=0&safe=off")
      last  = Regexp.new("http://www.google.ie/search?q=#{query}&num=50&start=200&safe=off")
      
      urls.first.should =~ first
      urls.last.should  =~ last      
    end
  end
  
  
end 
