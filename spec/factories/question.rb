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

  # "Full" factories - which contain detailed associations.

  factory :full_question_set, class: QuestionSet do
    name 'gasmixer'

    after(:create) do |question_set, evaluator|
      FactoryGirl.create_list(:full_question,  2, question_set: question_set)
      FactoryGirl.create_list(:dashboard_item, 2, question_set: question_set)
    end
  end

  factory :full_question, class: Question do
    text_nl        'Dutch text'
    text_de        'German text'
    text_en        'English text'
    description_nl 'Dutch description'
    description_de 'German description'
    description_en 'English description'

    question_set

    after(:create) do |question, evaluator|
      FactoryGirl.create_list(:answer, 2, question: question)
    end
  end

end
