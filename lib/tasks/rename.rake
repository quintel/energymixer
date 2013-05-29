require 'csv'

desc "Renames model attributes as specified in CSV file"
task :rename => [:environment] do

  model_name = ENV['model'].to_s.classify
  attribute  = ENV['attribute']
  file_name  = ENV['file']
  force      = ENV['force'] && ENV['force'].upcase == 'TRUE'
  revert     = ENV['revert'] && ENV['reverse'].upcase == 'TRUE'

  validate_params(model_name, attribute, file_name)

  puts force_message(force)

  CSV.foreach(file_name) do |line|
    old_value, new_value = line

    old_value, new_value = new_value, old_value if revert

    instances = model_name.constantize.where(attribute.to_sym => old_value)

    puts "* WARNING: #{ old_value } could NOT be found" if instances.empty?

    instances.each do |instance|

      instance.send("#{ attribute }=", new_value)
      instance.save! if force
      puts "* RENAMED: #{ instance.to_s } has been renamed from #{ old_value } to #{ new_value }"

    end

  end

  puts force_message(force)

end

# Helper method: raises error unless the params make sense in this context
def validate_params(model_name, attribute, file_name)
  unless defined?(model_name)
    raise "Invalid model: #{ model_name }"
  end

  unless model_name.constantize.new.respond_to?(attribute)
    raise "Invalid attribute: #{ model_name } doesn't have #{ attribute } attribute"
  end

  raise "No such file: #{ file_name }" unless File.exists?(file_name)
end

# Helper method: returns a string telling the User whether or not he is in
# force mode or not.
def force_message(force)
  if force
    "Bulk update has started FOR REAL"
  else
    "Bulk update has started in DRY-RUN mode. add force=true to really do it."
  end
end
