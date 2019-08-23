require "water_supplier_search/base/database"
require 'csv'
require 'net/http'
require 'json'

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
      CSV.foreach("lib/tasks/postcodes.csv", "r") do |row|
        @tasks << row
      end
    end

    50.times do
      Thread.new do
        while (row = @tasks.pop)
          postcode = row[0]
          if i != 0
            if @db.search(postcode).nil?
              name = request_for_supplier_name(postcode)

              save_to_db(postcode, name)

              sleep(0.02)
            end
          end

          i+=1

          print "/\r #{i}"
        end
      end
    end

    Thread.new do
      sleep 1 until @tasks.size.zero?
    end.join
  end

  def request_for_supplier_name(postcode)
    uri = URI.parse("https://suppliers.water.org.uk/?postcode=#{postcode}&json=true&platform=wateruk")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.get(uri.request_uri)

    data = JSON.parse(response.body)

    unless data['result'].nil?
      result = data['result'].scan(/>(.*)<\/a>/)
      unless result[0].nil?
        @result = result[0][0]
      end
    end
    @result
  end

  def save_to_db(postcode, name)
    if @db.search(postcode).nil?
      @db.insert(postcode, name) unless name.nil?
    end
  end
end
