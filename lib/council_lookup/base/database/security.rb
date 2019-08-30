module CouncilLookup
  module Base
    module Database
      module Security
        COLUMNS = [
            :postcode,
            :local_authority_name,
            :country_code,
            :country_name,
            :local_authority_code
        ].freeze

        private

        def check_columns columns
          columns.each{|column| raise("Use available columns: #{COLUMNS}") unless COLUMNS.include?(column)}
        end
      end
    end
  end
end