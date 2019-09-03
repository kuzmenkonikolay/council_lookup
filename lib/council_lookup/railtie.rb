class CouncilLookup::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/my_task.rake'
  end
end