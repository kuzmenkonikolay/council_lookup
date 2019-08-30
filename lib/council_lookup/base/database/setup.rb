require 'sqlite3'
require 'council_lookup/base/database/queries_helper'
require 'council_lookup/base/database/security'

module CouncilLookup
  module Base
    module Database
      class Setup
        include CouncilLookup::Base::Database::QueriesHelper
        include CouncilLookup::Base::Database::Security

        def initialize
          @db = SQLite3::Database.open 'councils'

          create_councils_table
          create_indexes
        end

        private

        def create_councils_table
          @db.execute <<-SQL
          create table if not exists councils(
           local_authority_name text,
           country_code varchar(30),
           country_name varchar(30),
           local_authority_code varchar(30),
           postcode varchar(30)
         );
          SQL
        end

        def create_indexes
          create_index('postcode')
          create_index('local_authority_code')
          create_index('country_code')
        end

        def create_index index
          @db.execute <<-SQL
            CREATE INDEX if not exists "councils_#{index}_index" ON councils("#{index}")
          SQL
        end
      end
    end
  end
end