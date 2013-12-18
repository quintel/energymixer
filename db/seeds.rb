Rails.root.join('db/seeds').children.each do |file|
  next unless file.to_s.end_with?('.yml')

  records = YAML.load(file.read)
  model   = file.basename('.yml').to_s.classify.constantize

  puts "Creating #{ file.basename('.yml').to_s.humanize }"

  records.each do |data|
    record = model.new

    # Bypass protected attributes.
    data.each { |key, value| record.__send__("#{ key }=", value) }

    record.save(validate: false)
  end
end

password = SecureRandom.hex[0..8]

User.create!(
  email:                'admin@quintel.com',
  password:              password,
  password_confirmation: password
)

puts "Created admin user admin@quintel.com with password: #{ password }"
