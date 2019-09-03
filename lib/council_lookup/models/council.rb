module CouncilLookup
  module Models
    class Council
      attr_accessor :postcode
      attr_accessor :local_authority_name
      attr_accessor :country_code
      attr_accessor :country_name
      attr_accessor :local_authority_code

      def initialize arr
        self.postcode = arr[4]
        self.local_authority_name = arr[0]
        self.country_code = arr[1]
        self.country_name = arr[2]
        self.local_authority_code = arr[3]
      end
    end
  end
end
