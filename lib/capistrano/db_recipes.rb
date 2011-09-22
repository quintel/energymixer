desc "Move db server to local db"
task :db2local do
  file = dump_db_to_tmp
  puts "Gzipping sql file"
    run "gzip -f #{file}"
  puts "Downloading gzip file"
    get file + ".gz", "#{db_name}.sql.gz"
  puts "Gunzip gzip file"
    system "gunzip -f #{db_name}.sql.gz"
  puts "Importing sql file to db"
    system "mysqladmin -f -u root drop #{local_db_name}"
    system "mysqladmin -u root create #{local_db_name}"
    system "mysql -u root #{local_db_name} < #{db_name}.sql"
end

# Helper methods

# dumps the entire db to the tmp folder and returns the full filename
# the optional tables parameter should be an array of string
def dump_db_to_tmp(tables = [])
  file = "/tmp/#{db_name}.sql"
  puts "Exporting db to sql file, filename: #{file}"
  run "mysqldump -u #{db_user} --password=#{db_pass} --host=#{db_host} #{db_name} #{tables.join(' ')}> #{file}"
  file
end

# watchout! this works on remote boxes, not on the developer box
def load_sql_into_db(file)
  puts "Importing sql file to db"
  run "mysql -u #{db_user} --password=#{db_pass} --host=#{db_host} #{db_name} < #{file}"
end
