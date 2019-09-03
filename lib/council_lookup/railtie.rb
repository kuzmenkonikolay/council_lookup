class CouncilLookup::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/download_db.rake'
  end
end