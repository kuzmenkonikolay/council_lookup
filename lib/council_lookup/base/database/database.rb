module CouncilLookup
  module Base
    module Database
      class Connect < Setup
        def select_all
          @db.execute <<-SQL
          select * from water_suppliers;
          SQL
        end

        def insert postcode, name
          @db.execute('INSERT INTO water_suppliers(postcode, name) VALUES(?, ?)', [postcode, name])
        end

        def search postcode
          @db.execute('SELECT * FROM water_suppliers WHERE postcode=?', postcode)[0]
        end

        def all_count
          @db.execute <<-SQL
          select COUNT(*) from water_suppliers;
          SQL
        end
      end
    end
  end
end
