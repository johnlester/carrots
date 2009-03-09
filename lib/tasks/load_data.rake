namespace :db do
  desc 'Fill the database tables with data from YAML files'
  task :load_data do

    Merb.start_environment(:environment => ENV['MERB_ENV'] || 'development')    
    
    tables_to_load = ["powers"]
    
    # load data
    tables_to_load.each do |table_name|
      file = File.join(Merb.root, "config", "data", "#{table_name}.yml")
      if File.exists?(file)
        klass = Object.full_const_get(table_name.singularize.camel_case)
        YAML.load_file(file).each do |record|
          klass.new(record).save
        end
      end
    end

  end # task
end # namespace