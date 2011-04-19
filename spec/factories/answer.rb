Factory.define :answer do |f|
  f.sequence(:answer) {|n| "Answer ##{n}"}
  f.description "lorem ipsum"
  f.inputs {|i| Array.new(3).map{ i.association(:input)} }
end

Factory.define :answer_with_question, :parent => :answer do |f|
  f.association :question, :factory => :question
end