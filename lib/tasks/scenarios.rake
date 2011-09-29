namespace :scenarios do
  desc 'Creates average scenarios'
  task :create_average => :environment do
    Scenario.averages.destroy_all
    
    [
      {:title => "< 19 jaar",      :range => 1..19},
      {:title => "20 tot 29 jaar", :range => 20..29},
      {:title => "30 tot 39 jaar", :range => 30..39},
      {:title => "40 tot 49 jaar", :range => 40..49},
      {:title => "50 tot 64 jaar", :range => 50..64},
      {:title => "> 65 jaar",      :range => 65..200}
    ].each do |scenario|
      records = Scenario.where(:age => scenario[:range])
      next if records.count == 0

      s = Scenario.new
      s.average = true
      s.email = "foobar@quintel.com"
      s.name  = scenario[:title]
      0.upto(12) do |i|
        sym = "output_#{i}".to_sym
        avg = records.average(sym)
        s[sym] = avg
      end    
      s.save
    end
  end
  
  desc "Clear cache"
  task :clear_cache => :environment do
    Rails.cache.clear
  end
  
  desc "Saves current scenario as featured"
  task :create_current => :environment do
    title = I18n.t('current_scenario')
    Scenario.featured.find_by_title(title).destroy_all rescue nil
    s = Scenario.new(Scenario.current.attributes)
    s.name = title
    s.title = title
    s.featured = true
    s.save!
  end
end
