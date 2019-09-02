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
          if @db.find(postcode).nil?
            @db.execute('INSERT INTO councils(postcode, local_authority_name, country_code, country_name, local_authority_code) VALUES(?, ?, ?, ?, ?)', [
                postcode, name, country_code, country_name, local_authority_code
            ])
          else
            raise("Council with Postcode: #{postcode} already exist")
          end
        end

        def find postcode
          @db.execute('SELECT * FROM councils WHERE lower(postcode)=?', postcode.downcase)[0]
        end

        def where arr
          @db.execute("SELECT * FROM councils WHERE postcode IN (#{arr})")
        end

        def pluck column, arr
          @db.execute("SELECT #{column} FROM councils WHERE postcode IN (#{arr})").flatten
        end

        def all_count
          @db.execute <<-SQL
            select COUNT(*) from councils;
          SQL
        end

        def find_by *args
          @db.execute("SELECT * FROM councils WHERE #{formation_where(args[0])}")[0]
        end

        def update postcode, column, value
          @db.execute("UPDATE councils SET '#{column}'='#{value}' WHERE lower(postcode)=?", postcode.downcase)
        end

        def delete postcode
          @db.execute("DELETE FROM councils WHERE lower(postcode)=?", postcode.downcase)
        end
      end
    end
  end
end
