namespace :questions do
  desc 'Dumps translations'
  task :dump => :environment do
    
    
    set = QuestionSet.first
    
    set.questions.ordered.each do |q|
      puts "Question ##{q.number}"
      puts "==========="
      puts q.text_nl
      puts
      puts q.description_nl
      puts
      puts
      puts "Answers"
      puts "-------"
      puts
      q.answers.each do |a|
        puts a.text_nl
        puts
        # puts a.description_nl
        puts
      end
      puts
      puts
    end
    
    puts "Popups"
    puts "======"
    Popup.all.each do |p|
      puts p.title_nl
      puts
      puts p.body_nl
      puts
      puts
    end
  end
end
