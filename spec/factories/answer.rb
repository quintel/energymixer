FactoryGirl.define do
  factory :answer do |f|
    f.text_de "lorem ipsum"
    f.text_nl "lorem ipsum"
    f.description_de "lorem ipsum"
    f.description_nl "lorem ipsum"
    f.inputs {|i| Array.new(3).map{ i.association(:input)} }
  end

  factory :answer_with_question, :parent => :answer do |f|
    f.association :question, :factory => :question
  end
end
