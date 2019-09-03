desc 'Download Database'
namespace :download do
  task :db do
    require 'uri'
    require 'tempfile'
    require 'net/http'
    require 'net/https'
    require 'json'

    uri = URI.parse("https://content.dropboxapi.com/2/files/download")
    req = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/octet-stream','Authorization' =>"Bearer 2yAY3ttohrAAAAAAAAAAJ2Fffvt-_2TP8a9J4iGNnLGpMPG6SSoPZ3uAWTmGpk_Z", 'Dropbox-API-Arg' => "{\"path\": \"/councils\"}"})

    full_length = 220712960
    progress = 0

    DIRECTORY = __dir__.gsub('/tasks', '').freeze

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
      http.request(req) do |response|
        File.open("#{DIRECTORY}/councils", 'w') do |f|
          response.read_body do |chunk|
            f.write chunk.encoding
            progress += chunk.length
            print "/\r COUNCIL LOOKUP: Downloading Councils DB: #{(progress*100)/full_length}%"
          end
        end
        p 'Done.'
      end
    }
  end
end