namespace :users do
  desc 'Creates an admin user with password supplied by PASSWORD=adminpassword'
  task :create_admin => :environment do
    password = ENV['PASSWORD']
    user = User.new(:email => 'admin@quintel.com', :password => password)
    if user.save
      puts 'Successfully created admin user.'
    else
      puts user.errors.full_messages.to_sentence
    end
  end
end
