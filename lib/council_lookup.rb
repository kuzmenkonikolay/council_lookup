require "council_lookup/version"
require "council_lookup/railtie" if defined?(Rails)

require 'council_lookup/base/database/database'

module CouncilLookup
  def self.connect
    CouncilLookup::Base::Database::Connect.new
  end
end