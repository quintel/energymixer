Factory.define :answer_conflict do |f|
  f.association :answer, :factory => :answer
  f.association :other_answer, :factory => :answer
end