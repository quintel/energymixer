FactoryGirl.define do
  factory :question_set do |f|
    f.name 'gasmixer'
  end

  factory :question do |f|
    f.sequence(:text_nl) {|n| "Question ##{n}"}
    f.answers {|a| Array.new(2).map { a.association(:answer) } }
    f.description_nl "foo"
    f.description_de "foo"  
    f.association :question_set
  end
end
