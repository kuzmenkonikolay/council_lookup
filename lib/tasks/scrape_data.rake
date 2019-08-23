require 'csv'
require 'net/http'
require 'json'

require 'council_lookup/base/database/database'

desc 'Load data from resource'
namespace :scrape_data do
  task :parse do
    @db = CouncilLookup::Base::Database::Connect.new
    @tasks = Queue.new

    parse_csv_postcodes
  end

  def parse_csv_postcodes
    i = 0

    Thread.new do
      CSV.foreach("lib/tasks/councils.csv", "r") do |row|
        @tasks << row
      end
    end

    30.times do
      Thread.new do
        while (row = @tasks.pop)
          postcode = row[0]
          country_code = row[3]
          country_name = row[4]
          local_authority_code = row[5]
          local_authority_name = row[6]


          save_to_db(postcode, local_authority_name, country_code, country_name, local_authority_code) if i != 0

          i+=1

          print "/\r #{i}"
        end
      end
    end

    Thread.new do
      sleep 1 until @tasks.size.zero?
    end.join
  end

  def save_to_db(postcode, name, country_code, country_name, local_authority_code)
    if @db.search(postcode).nil?
      @db.insert(postcode, name, country_code, country_name, local_authority_code) unless name.nil?
    end
  end
end
