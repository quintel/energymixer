namespace :questions do
  desc 'Dumps question set'
  task :dump => :environment do
    set = QuestionSet.first
    set.questions.ordered.each do |q|
      puts "Question ##{q.number}\n***********"
      puts "Text: #{q.question}\n"
      puts "Info: #{q.information}\n"
      puts
      puts "Answers\n*******"
      q.answers.each do |a|
        puts "Text: #{a.answer}\n"
        puts "Info: #{a.description}\n"
        puts
      end
      puts
      puts
    end
  end
end
