Dir.glob(Rails.root.join('db/seeds/*.yml').to_s).reverse_each do |yaml_filename|
  table_name = File.basename(yaml_filename.split('-').last, '.yml')
  ActiveRecord::Base.connection.execute("DELETE FROM #{table_name}")
  ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
  puts "Deleted records from #{table_name} table."
end

Dir.glob("#{Rails.root}/db/seeds/*.yml").each do |yaml_filename|
  name = File.basename(yaml_filename, '.yml')
  table = name.split('-').last
  File.open(yaml_filename) do |load_target_yaml|
    records = YAML.unsafe_load(load_target_yaml) || []
    if records.present?
      target_model = table.classify.constantize

      records.each do |record|
        target_model.create!(record)
      end

      puts "created #{records.length} #{target_model} records"
    end
  end

  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end
