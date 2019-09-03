require 'csv'
require 'json'

require 'council_lookup/base/database/database'

desc 'Load data from resource'
namespace :scrape_data do
  task :parse do
    @db = CouncilLookup::Base::Database::Connect.new
    @tasks = Queue.new

    parse_csv_postcodes
    correcting_data
  end

  def parse_csv_postcodes
    i = 0

    Thread.new do
      CSV.foreach("lib/tasks/councils.csv", "r") do |row|
        @tasks << row
      end
    end

    50.times do
      Thread.new do
        while (row = @tasks.pop)
          postcode = row[0]
          country_code = row[3]
          country_name = row[4]
          local_authority_code = row[5]
          local_authority_name = row[6]

          save_to_db(postcode, local_authority_name, country_code, country_name, local_authority_code)

          i+=1

          print "/\r #{i}"
        end
      end
    end

    Thread.new do
      sleep 0.1 until @tasks.size.zero?
    end.join
  end

  def correcting_data

    @global_index = 1
    array_of_rows = {}
    array_of_ids = []
    i = 0
    CSV.foreach("lib/tasks/councils.csv", "r") do |row|
      if i < 10000
        i+=1
        array_of_rows[row[0]] = row
        array_of_ids << row[0]
      else
        if i==10000
          parsed_array_of_ids = "'#{array_of_ids.join("', '")}'"
          existed_postcodes = @db.pluck('postcode', parsed_array_of_ids)

          if existed_postcodes.size < 10000
            blank_postcodes = []
            array_of_ids.each{|el| blank_postcodes << el unless existed_postcodes.include?(el)}

            blank_postcodes.each do |postcode|
              row = array_of_rows[postcode]

              postcode = row[0]
              country_code = row[3]
              country_name = row[4]
              local_authority_code = row[5]
              local_authority_name = row[6]

              save_to_db(postcode, local_authority_name, country_code, country_name, local_authority_code)
            end
          end
          array_of_rows = {}
          array_of_ids = []
          i=0
        end
      end
    end
  end

  def save_to_db(postcode, name, country_code, country_name, local_authority_code)
    if @db.find(postcode).nil?
      print "/\r #{@global_index}"
      @global_index+=1
      @db.insert(postcode, name, country_code, country_name, local_authority_code)
    end
  end
end
