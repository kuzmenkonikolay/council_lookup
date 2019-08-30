module CouncilLookup
  module Base
    module Database
      module QueriesHelper
        private

        def parse_array_to_s arr
          "'#{arr.join("', '")}'"
        end

        def formation_where hash
          check_columns(hash.keys)

          query = ''
          loop_amount = hash.keys.size
          hash.keys.each_with_index do |key, i|
            query+="#{key}='#{hash[key]}'"
            query+=' AND ' if loop_amount>i+1
            i+=1
          end
          query
        end
      end
    end
  end
end