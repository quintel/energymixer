Factory.define :answer_conflict do |f|
  f.association :answer, :factory => :answer_with_question
  f.association :other_answer, :factory => :answer_with_question
end