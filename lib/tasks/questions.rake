namespace :questions do
  desc 'Dumps translations'
  task :dump => :environment do
    
    puts "# Questions"
    
    Question.ordered.each do |q|
      puts "## Question ##{q.number}"
      puts "##### Dutch"
      puts q.text_nl
      puts
      puts "*#{q.description_nl.strip!}*" unless q.description_nl.empty?
      puts
      puts "##### English"
      puts q.text_en
      puts
      puts "*#{q.description_en.strip!}*" unless q.description_en.empty?
      puts
      puts "### Answers"
      puts
      q.answers.ordered.each do |a|
        puts "#### Answer ##{a.ordering}"
        puts "##### Dutch"
        puts ""
        puts a.text_nl
        puts "##### English"
        puts ""
        puts a.text_en
        puts
        puts
      end
      puts
      puts
    end
    
    puts "# Popups"
    Popup.all.each do |p|
      puts "### Dutch"
      puts "##### #{p.title_nl}"
      puts
      puts "#{p.body_nl}"
      puts
      puts "### English"
      puts "##### #{p.title_en}"
      puts
      puts "#{p.body_en}"
      puts
    end
  end
end
