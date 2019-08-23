require 'council_lookup/base/database/setup'

module CouncilLookup
  module Base
    module Database
      class Connect < Setup
        def select_all
          @db.execute <<-SQL
            select * from councils;
          SQL
        end

        def insert postcode, name, country_code, country_name, local_authority_code
          @db.execute('INSERT INTO councils(postcode, local_authority_name, country_code, country_name, local_authority_code) VALUES(?, ?)', [
              postcode, name, country_code, country_name, local_authority_code
          ])
        end

        def search postcode
          @db.execute('SELECT * FROM councils WHERE lower(postcode)=?', postcode.downcase)[0]
        end

        def all_count
          @db.execute <<-SQL
            select COUNT(*) from councils;
          SQL
        end
      end
    end
  end
end
