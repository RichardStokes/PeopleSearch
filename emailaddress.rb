
class EmailAddress
   
   include Comparable
   
   # The email address string
   attr_reader :address
   
   # The ranking of the address in terms of
   # it's relevance to our search
   attr_accessor :ranking
   
   def initialize(address, ranking = 0)
     @address = address
     @ranking = ranking
   end
   
   def <=> (other)
     self.ranking <=> other.ranking
   end
end
